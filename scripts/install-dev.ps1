param(
    [Parameter(Mandatory = $true)]
    [string]$VaultPath
)

$ErrorActionPreference = "Stop"

$PluginId = "synapse-link"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

# Remove aspas extras adicionadas ao informar o caminho do vault.
$VaultPath = $VaultPath.Trim('"')

# Valida se o vault informado existe antes de iniciar a instalação do plugin.
if (-not (Test-Path $VaultPath)) {
    Write-Host ""
    Write-Host "ERRO: O vault informado nao existe:" -ForegroundColor Red
    Write-Host $VaultPath -ForegroundColor Yellow
    exit 1
}

$ObsidianDirectory = Join-Path $VaultPath ".obsidian"
$PluginsDirectory = Join-Path $ObsidianDirectory "plugins"
$PluginDirectory = Join-Path $PluginsDirectory $PluginId

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Instalando SynapseLink no Obsidian" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Cria .obsidian caso ainda não exista.
if (-not (Test-Path $ObsidianDirectory)) {
    Write-Host "Criando pasta .obsidian..." -ForegroundColor Yellow
    New-Item `
        -ItemType Directory `
        -Path $ObsidianDirectory `
        -Force | Out-Null
}

# Cria .obsidian/plugins caso ainda não exista.
if (-not (Test-Path $PluginsDirectory)) {
    Write-Host "Criando pasta de plugins..." -ForegroundColor Yellow
    New-Item `
        -ItemType Directory `
        -Path $PluginsDirectory `
        -Force | Out-Null
}

# Cria a pasta específica do plugin.
if (-not (Test-Path $PluginDirectory)) {
    Write-Host "Criando pasta do SynapseLink..." -ForegroundColor Yellow
    New-Item `
        -ItemType Directory `
        -Path $PluginDirectory `
        -Force | Out-Null
}

# Arquivos obrigatórios e opcionais.
$FilesToCopy = @(
    @{
        Name       = "manifest.json"
        Candidates = @(
            (Join-Path $ProjectRoot "dist\manifest.json"),
            (Join-Path $ProjectRoot "manifest.json")
        )
        Required = $true
    },
    @{
        Name       = "main.js"
        Candidates = @(
            (Join-Path $ProjectRoot "dist\main.js"),
            (Join-Path $ProjectRoot "main.js")
        )
        Required = $true
    },
    @{
        Name       = "styles.css"
        Candidates = @(
            (Join-Path $ProjectRoot "dist\styles.css"),
            (Join-Path $ProjectRoot "src\styles.css"),
            (Join-Path $ProjectRoot "styles.css")
        )
        Required = $false
    }
)

foreach ($File in $FilesToCopy) {
    $SourcePath = $null

    foreach ($Candidate in $File.Candidates) {
        if (Test-Path $Candidate) {
            $SourcePath = $Candidate
            break
        }
    }

    if ($null -eq $SourcePath) {
        if ($File.Required) {
            Write-Host ""
            Write-Host "ERRO: Arquivo obrigatorio nao encontrado: $($File.Name)" `
                -ForegroundColor Red

            if ($File.Name -eq "main.js") {
                Write-Host "Execute o build antes de instalar:" `
                    -ForegroundColor Yellow
                Write-Host "npm run build" -ForegroundColor White
            }

            exit 1
        }

        Write-Host "Ignorado: $($File.Name) nao existe." `
            -ForegroundColor DarkGray
        continue
    }

    $DestinationPath = Join-Path $PluginDirectory $File.Name

    Copy-Item `
        -Path $SourcePath `
        -Destination $DestinationPath `
        -Force

    Write-Host "Copiado: $($File.Name)" -ForegroundColor Green
}

Write-Host ""
Write-Host "SynapseLink instalado com sucesso em:" -ForegroundColor Green
Write-Host $PluginDirectory -ForegroundColor White
Write-Host ""
Write-Host "No Obsidian, use Ctrl + R para recarregar." -ForegroundColor Cyan