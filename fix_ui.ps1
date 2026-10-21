$path = "D:\gemini\kalkulator-saham\index.html"
$bytes = [System.IO.File]::ReadAllBytes($path)
$str = [System.Text.Encoding]::UTF8.GetString($bytes)

# 1. Ganti blok tombol pilihan cepat dengan pills modern dan rapi
$pattButtons = '(?s)<!-- Quick Category Filter Pills -->.*?</div>\s*</div>\s*<!-- STRATEGI'

$cleanButtons = @"
<!-- Quick Category Filter Pills -->
      <div class="flex flex-wrap items-center justify-center gap-2 pt-3">
        <span class="text-xs text-slate-500 font-medium">Pilihan Cepat:</span>
        <button onclick="selectStock('BRIS')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">BRIS</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 1.320</span>
        </button>
        <button onclick="selectStock('ICBP')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">ICBP</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 7.025</span>
        </button>
        <button onclick="selectStock('SIDO')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">SIDO</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 350</span>
        </button>
        <button onclick="selectStock('ANTM')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">ANTM</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 3.100</span>
        </button>
        <button onclick="selectStock('PTBA')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">PTBA</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 3.260</span>
        </button>
        <button onclick="selectStock('SMRA')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">SMRA</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 256</span>
        </button>
        <button onclick="selectStock('BUAH')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
          <span class="font-bold text-white">BUAH</span>
          <span class="text-emerald-400 font-mono text-[11px]">Rp 486</span>
        </button>
        <button onclick="selectStock('PANI')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-rose-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-rose-400"></span>
          <span class="font-bold text-white">PANI</span>
          <span class="text-rose-400 font-mono text-[11px]">Rp 4.760</span>
          <span class="text-[9px] px-1 py-0.2 rounded bg-rose-950/80 text-rose-300 border border-rose-800/40 font-semibold">Non-DES</span>
        </button>
        <button onclick="selectStock('BBCA')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-rose-500/50 transition flex items-center gap-1.5 shadow-sm">
          <span class="w-2 h-2 rounded-full bg-rose-400"></span>
          <span class="font-bold text-white">BBCA</span>
          <span class="text-rose-400 font-mono text-[11px]">Rp 5.950</span>
          <span class="text-[9px] px-1 py-0.2 rounded bg-rose-950/80 text-rose-300 border border-rose-800/40 font-semibold">Non-DES</span>
        </button>
      </div>
    </div>

    <!-- STRATEGI
"@

if ($str -match $pattButtons) {
    $str = $str -replace $pattButtons, $cleanButtons
    Write-Host "Berhasil mengganti tombol pilihan cepat!" -ForegroundColor Green
} else {
    Write-Host "Pola tombol tidak cocok!" -ForegroundColor Red
}

# 2. Bersihkan judul Skenario Bear, Normal, Bull
$str = $str -replace '>[^<]*Skenario Bear \(Pesimis\)', '><span class="w-2 h-2 rounded-full bg-rose-400 inline-block mr-1"></span>Skenario Bear (Pesimis)'
$str = $str -replace '>[^<]*Skenario Normal \(Konsensus\)', '><span class="w-2 h-2 rounded-full bg-emerald-400 inline-block mr-1"></span>Skenario Normal (Konsensus)'
$str = $str -replace '>[^<]*Skenario Bull \(Optimis\)', '><span class="w-2 h-2 rounded-full bg-indigo-400 inline-block mr-1"></span>Skenario Bull (Optimis)'

# 3. Bersihkan teks mojibake di innerHTML JS
$str = $str -replace 'âœ…', '✓'
$str = $str -replace 'âš–ï¸', '⚖'
$str = $str -replace 'âš ï¸', '⚠'
$str = $str -replace 'â Œ', '✗'
$str = $str -replace 'âš¡', '⚡'
$str = $str -replace 'ðŸ ›ï¸', '🕌'
$str = $str -replace 'ðŸ ¢', '🏢'
$str = $str -replace 'ðŸ¥£', '🥣'
$str = $str -replace 'ðŸŒ¿', '🌿'
$str = $str -replace 'ðŸª™', '🪙'
$str = $str -replace 'ðŸ »', '🐻'
$str = $str -replace 'ðŸ ‚', '🐂'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $str, $utf8NoBom)
Write-Host "Berhasil membersihkan seluruh karakter rusak di index.html!" -ForegroundColor Green
