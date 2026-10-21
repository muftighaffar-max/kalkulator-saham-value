/**
 * fundamental_state_manager.js
 * State Manager & Caching Layer for IDX Stock Fundamentals.
 * 
 * Supports:
 * - High-speed in-memory Map cache
 * - Persistent IndexedDB storage (handles 900+ emiten without 5MB quota limits)
 * - Automatic fallback to localStorage when IndexedDB is blocked (e.g. private mode)
 * - TTL (Time to Live) validation and cache invalidation
 */

(function (window) {
  'use strict';

  const DB_NAME = 'IDX_Fundamental_DB';
  const DB_VERSION = 1;
  const STORE_NAME = 'emiten_fundamentals';
  const LOCAL_STORAGE_KEY = 'kalkulatorSaham.fundamentalsCache.v2';
  const DEFAULT_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 hari

  class FundamentalStateManager {
    constructor() {
      this.memoryCache = new Map();
      this.db = null;
      this.isIndexedDBAvailable = false;
      this.initPromise = null;
    }

    async init() {
      if (this.initPromise) return this.initPromise;
      this.initPromise = this._initInternal();
      return this.initPromise;
    }

    async _initInternal() {
      // 1. Load initial data from localStorage if exists
      this._loadFromLocalStorage();

      // 2. Initialize IndexedDB
      if (typeof window !== 'undefined' && 'indexedDB' in window) {
        try {
          this.db = await this._openIndexedDB();
          this.isIndexedDBAvailable = true;
          // Hydrate memory cache from IndexedDB
          await this._hydrateFromIndexedDB();
        } catch (err) {
          console.warn('[FundamentalStateManager] IndexedDB unavailable, continuing with localStorage fallback:', err);
          this.isIndexedDBAvailable = false;
        }
      }

      // 3. Import pre-bundled cache from cached_fundamentals.js if memoryCache is empty or missing tickers
      if (window.preloadedFundamentals && typeof window.preloadedFundamentals === 'object') {
        let imported = 0;
        for (const [ticker, item] of Object.entries(window.preloadedFundamentals)) {
          if (!this.memoryCache.has(ticker)) {
            this.memoryCache.set(ticker, item);
            imported++;
          }
        }
        if (imported > 0) {
          console.info(`[FundamentalStateManager] Loaded ${imported} preloaded emiten fundamentals.`);
        }
      }

      // 4. Integrate curated fundamentals for high-profile emiten (if not already live synced)
      if (window.curatedFundamentals && typeof window.curatedFundamentals === 'object') {
        for (const [ticker, item] of Object.entries(window.curatedFundamentals)) {
          const existing = this.memoryCache.get(ticker);
          if (!existing || existing.syncStatus !== 'live') {
            const pre = (window.preloadedFundamentals && window.preloadedFundamentals[ticker]) || {};
            this.memoryCache.set(ticker, {
              ...pre,
              ...item,
              syncStatus: 'cached',
              source: item.source || 'Data Kurasi Resmi',
              lastUpdated: item.lastUpdated || (existing && existing.lastUpdated) || new Date().toISOString()
            });
          }
        }
      }

      return this;
    }

    _openIndexedDB() {
      return new Promise((resolve, reject) => {
        const req = window.indexedDB.open(DB_NAME, DB_VERSION);
        req.onupgradeneeded = (e) => {
          const db = e.target.result;
          if (!db.objectStoreNames.contains(STORE_NAME)) {
            const store = db.createObjectStore(STORE_NAME, { keyPath: 'ticker' });
            store.createIndex('lastUpdated', 'lastUpdated', { unique: false });
            store.createIndex('syncStatus', 'syncStatus', { unique: false });
          }
        };
        req.onsuccess = (e) => resolve(e.target.result);
        req.onerror = (e) => reject(e.target.error);
      });
    }

    async _hydrateFromIndexedDB() {
      if (!this.db) return;
      return new Promise((resolve) => {
        try {
          const tx = this.db.transaction(STORE_NAME, 'readonly');
          const store = tx.objectStore(STORE_NAME);
          const req = store.getAll();
          req.onsuccess = () => {
            const list = req.result || [];
            list.forEach(item => {
              if (item && item.ticker) {
                this.memoryCache.set(item.ticker, item);
              }
            });
            resolve();
          };
          req.onerror = () => resolve();
        } catch (e) {
          resolve();
        }
      });
    }

    _loadFromLocalStorage() {
      try {
        const raw = localStorage.getItem(LOCAL_STORAGE_KEY);
        if (raw) {
          const parsed = JSON.parse(raw);
          if (parsed && typeof parsed === 'object') {
            Object.entries(parsed).forEach(([k, v]) => {
              // Abaikan data korup dengan BVPS 0 atau skala USD mentah
              if (v && (v.bvps === 0 || (v.price > 100 && v.bvps > 0 && v.bvps < 5))) {
                return;
              }
              this.memoryCache.set(k, v);
            });
          }
        }
      } catch (e) {
        // Ignored, private browsing or quota
      }
    }

    _saveToLocalStorage() {
      try {
        // Save top 200 most recently updated tickers to fit nicely in 5MB quota
        const entries = Array.from(this.memoryCache.entries()).filter(([k, v]) => {
          return v && v.bvps > 0 && !(v.price > 100 && v.bvps < 5);
        });
        entries.sort((a, b) => {
          const tA = new Date(a[1].lastUpdated || 0).getTime();
          const tB = new Date(b[1].lastUpdated || 0).getTime();
          return tB - tA;
        });
        const slice = Object.fromEntries(entries.slice(0, 200));
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(slice));
      } catch (e) {
        // localStorage quota full or disabled
      }
    }

    /**
     * Retrieve fundamental data for a ticker.
     * @param {string} ticker 
     * @param {boolean} allowExpired 
     * @returns {object|null}
     */
    get(ticker, allowExpired = true) {
      if (!ticker) return null;
      const clean = ticker.toUpperCase().trim();
      let record = this.memoryCache.get(clean);
      if (!record) return null;

      if (typeof window !== 'undefined' && typeof window.sanitizeStockFundamentals === 'function') {
        record = window.sanitizeStockFundamentals(record);
      } else if (record.bvps <= 0 || (record.price > 100 && record.bvps < 5)) {
        const pbv = (record.targetPBV && record.targetPBV > 0 && record.targetPBV <= 50) ? record.targetPBV : 1.4;
        if (record.price > 0) record.bvps = Math.round((record.price / pbv) * 10) / 10;
      }

      if (!allowExpired && record.lastUpdated) {
        const age = Date.now() - new Date(record.lastUpdated).getTime();
        if (age > DEFAULT_TTL_MS) {
          return null; // Expired
        }
      }
      return record;
    }

    /**
     * Check if ticker has valid fundamental data
     */
    has(ticker) {
      if (!ticker) return false;
      return this.memoryCache.has(ticker.toUpperCase().trim());
    }

    /**
     * Save single ticker fundamental data
     */
    async set(ticker, data) {
      if (!ticker || !data) return;
      const clean = ticker.toUpperCase().trim();
      data.ticker = clean;
      if (!data.lastUpdated) data.lastUpdated = new Date().toISOString();

      // Memory
      this.memoryCache.set(clean, data);

      // IndexedDB
      if (this.db) {
        try {
          const tx = this.db.transaction(STORE_NAME, 'readwrite');
          tx.objectStore(STORE_NAME).put(data);
        } catch (e) {
          console.warn('[FundamentalStateManager] IndexedDB put error:', e);
        }
      }

      // LocalStorage debounce / write
      this._saveToLocalStorage();
      return data;
    }

    /**
     * Save multiple tickers in a high-speed batch transaction
     */
    async setBatch(entries) {
      if (!entries || !entries.length) return;
      const now = new Date().toISOString();

      entries.forEach(item => {
        if (!item || !item.ticker) return;
        item.ticker = item.ticker.toUpperCase().trim();
        if (!item.lastUpdated) item.lastUpdated = now;
        this.memoryCache.set(item.ticker, item);
      });

      if (this.db) {
        try {
          const tx = this.db.transaction(STORE_NAME, 'readwrite');
          const store = tx.objectStore(STORE_NAME);
          entries.forEach(item => {
            if (item && item.ticker) store.put(item);
          });
        } catch (e) {
          console.warn('[FundamentalStateManager] IndexedDB batch error:', e);
        }
      }

      this._saveToLocalStorage();
    }

    /**
     * Get statistics on cached emiten data
     */
    getStats() {
      let live = 0, cached = 0, fallback = 0;
      let newest = 0;

      for (const item of this.memoryCache.values()) {
        if (item.syncStatus === 'live') live++;
        else if (item.syncStatus === 'cached') cached++;
        else fallback++;

        if (item.lastUpdated) {
          const t = new Date(item.lastUpdated).getTime();
          if (t > newest) newest = t;
        }
      }

      return {
        total: this.memoryCache.size,
        live,
        cached,
        fallback,
        lastUpdated: newest ? new Date(newest).toISOString() : null
      };
    }

    /**
     * Clear all cached data
     */
    async clear() {
      this.memoryCache.clear();
      try { localStorage.removeItem(LOCAL_STORAGE_KEY); } catch (e) {}
      if (this.db) {
        try {
          const tx = this.db.transaction(STORE_NAME, 'readwrite');
          tx.objectStore(STORE_NAME).clear();
        } catch (e) {}
      }
    }
  }

  // Export globally
  window.FundamentalStateManager = FundamentalStateManager;
  window.fundamentalState = new FundamentalStateManager();

})(window);
