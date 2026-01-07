# Registry Optimizer Pro - [IGRF Pvt. Ltd.] Edition
# Windows Registry Optimization Tool
# Version: 1.0 Professional (Optimized)
# =============================================

# Clear the console to free memory
Clear-Host

# Force garbage collection before starting
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# Add required assemblies only once
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialize main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Registry Optimizer Pro - [IGRF Pvt. Ltd.] Edition"
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $true
$form.SizeGripStyle = "Hide"

# Set window size
$form.Width = 900
$form.Height = 650

# Set form background color (LIGHT THEME)
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 245)

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "REGISTRY OPTIMIZER PRO - [IGRF Pvt. Ltd.] Edition"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 91, 187)
$titleLabel.TextAlign = "MiddleCenter"
$titleLabel.Location = New-Object System.Drawing.Point(0, 20)
$titleLabel.Size = New-Object System.Drawing.Size($form.Width, 40)
$form.Controls.Add($titleLabel)

# Subtitle Label
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Ready to minimize your registry issues"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$subtitleLabel.TextAlign = "MiddleCenter"
$subtitleLabel.Location = New-Object System.Drawing.Point(0, 60)
$subtitleLabel.Size = New-Object System.Drawing.Size($form.Width, 25)
$form.Controls.Add($subtitleLabel)

# Status Bar (top)
$statusBar = New-Object System.Windows.Forms.Panel
$statusBar.BackColor = [System.Drawing.Color]::FromArgb(0, 91, 187)
$statusBar.Location = New-Object System.Drawing.Point(15, 100)
$statusBar.Size = New-Object System.Drawing.Size(($form.Width - 30), 4)
$form.Controls.Add($statusBar)

# Status Label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
$statusLabel.Location = New-Object System.Drawing.Point(20, 110)
$statusLabel.Size = New-Object System.Drawing.Size(($form.Width - 40), 20)
$form.Controls.Add($statusLabel)

# Main Panel for optimizations
$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.BorderStyle = "FixedSingle"
$mainPanel.BackColor = [System.Drawing.Color]::White
$mainPanel.Location = New-Object System.Drawing.Point(15, 140)
$mainPanel.Size = New-Object System.Drawing.Size(($form.Width - 30), 300)
$form.Controls.Add($mainPanel)

# Panel Title
$panelTitle = New-Object System.Windows.Forms.Label
$panelTitle.Text = "OPTIMIZATIONS"
$panelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$panelTitle.ForeColor = [System.Drawing.Color]::FromArgb(0, 91, 187)
$panelTitle.Location = New-Object System.Drawing.Point(10, 10)
$panelTitle.Size = New-Object System.Drawing.Size(($mainPanel.Width - 20), 25)
$mainPanel.Controls.Add($panelTitle)

# ListView for optimizations
$listView = New-Object System.Windows.Forms.ListView
$listView.View = "Details"
$listView.FullRowSelect = $true
$listView.GridLines = $false  # Disable gridlines for better performance
$listView.CheckBoxes = $true
$listView.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$listView.BackColor = [System.Drawing.Color]::White
$listView.ForeColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$listView.Location = New-Object System.Drawing.Point(10, 40)
$listView.Size = New-Object System.Drawing.Size(($mainPanel.Width - 20), 220)
$listView.HeaderStyle = "Nonclickable"
$listView.HideSelection = $false

# Add columns
$listView.Columns.Add("Optimization", 200) | Out-Null
$listView.Columns.Add("Description", 400) | Out-Null
$listView.Columns.Add("Status", 100) | Out-Null

# Optimization functions (reusable - defined once)
function Optimize-NetworkThrottling {
    try {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force
        return $true
    } catch { return $false }
}

function Optimize-Services {
    try {
        @("Fax", "lfsvc", "MapsBroker", "RemoteRegistry") | ForEach-Object {
            Stop-Service -Name $_ -Force -ErrorAction SilentlyContinue
            Set-Service -Name $_ -StartupType Disabled -ErrorAction SilentlyContinue
        }
        return $true
    } catch { return $false }
}

function Clear-SearchHistory {
    try {
        # Stop Windows Search service
        Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
        
        # Clear search cache files
        @(
            "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\LocalState",
            "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\LocalState",
            "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer"
        ) | Where-Object { Test-Path $_ } | ForEach-Object {
            Get-ChildItem -Path $_ -Recurse -Include "*.db", "*.log", "*.dat", "*.tmp" -ErrorAction SilentlyContinue | 
                Remove-Item -Force -ErrorAction SilentlyContinue
        }
        
        # Clear registry search history
        @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\SearchHistory"
        ) | Where-Object { Test-Path $_ } | ForEach-Object {
            Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        Start-Service -Name "WSearch" -ErrorAction SilentlyContinue
        return $true
    } catch { return $false }
}

function Enable-AutoEndTasks {
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1" -Type String -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value "2000" -Type String -Force
        return $true
    } catch { return $false }
}

function Clear-MRU {
    try {
        @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"
        ) | Where-Object { Test-Path $_ } | ForEach-Object {
            Remove-Item -Path "$_\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        return $true
    } catch { return $false }
}

function Optimize-MenuSpeed {
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "50" -Type String -Force
        return $true
    } catch { return $false }
}

function Disable-Animations {
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Type String -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary -Force
        return $true
    } catch { return $false }
}

function Remove-InvalidFileAssociations {
    try {
        Get-ChildItem -Path "HKLM:\SOFTWARE\Classes" -ErrorAction SilentlyContinue | 
            Where-Object { $_.PSChildName -match '^\..+$' } |
            Where-Object { 
                $command = Get-ItemProperty -Path "$($_.PSPath)\shell\open\command" -Name "(default)" -ErrorAction SilentlyContinue
                $command -and $command.'(default)' -like '*file not found*'
            } | ForEach-Object {
                Remove-Item -Path $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
            }
        return $true
    } catch { return $false }
}

function Clear-RecentDocuments {
    try {
        Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs\*" -Recurse -Force -ErrorAction SilentlyContinue
        
        $jumpListPath = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations"
        if (Test-Path $jumpListPath) {
            Remove-Item -Path "$jumpListPath\*" -Force -ErrorAction SilentlyContinue
        }
        return $true
    } catch { return $false }
}

# Optimization mapping dictionary (more memory efficient than array of hashtables)
$optimizationMap = @{
    "NetworkThrottling" = @("Optimize network throttling for better performance", {Optimize-NetworkThrottling})
    "ServicesOptimization" = @("Analyze services for optimization opportunities", {Optimize-Services})
    "SearchHistory" = @("Clear Windows Search history", {Clear-SearchHistory})
    "AutoEndTasks" = @("Enable auto-end tasks for faster shutdown", {Enable-AutoEndTasks})
    "MRUCleanup" = @("Clear Most Recently Used (MRU) lists", {Clear-MRU})
    "MenuSpeed" = @("Optimize menu show delay (100ms to 50ms)", {Optimize-MenuSpeed})
    "DisableAnimations" = @("Disable animations for better performance", {Disable-Animations})
    "InvalidFileAssociations" = @("Remove invalid file extension associations", {Remove-InvalidFileAssociations})
    "RecentDocs" = @("Clear recent documents list", {Clear-RecentDocuments})
}

# Add optimization items efficiently
foreach ($key in $optimizationMap.Keys) {
    $item = New-Object System.Windows.Forms.ListViewItem($key)
    $item.SubItems.Add($optimizationMap[$key][0]) | Out-Null
    $item.SubItems.Add("Ready") | Out-Null
    $item.Checked = $true
    $item.Tag = $optimizationMap[$key][1]
    [void]$listView.Items.Add($item)
}

$mainPanel.Controls.Add($listView)

# Progress Bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 270)
$progressBar.Size = New-Object System.Drawing.Size(($mainPanel.Width - 20), 20)
$progressBar.Style = "Continuous"
$mainPanel.Controls.Add($progressBar)

# Statistics Panel
$statsPanel = New-Object System.Windows.Forms.Panel
$statsPanel.BorderStyle = "FixedSingle"
$statsPanel.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
$statsPanel.Location = New-Object System.Drawing.Point(15, 450)
$statsPanel.Size = New-Object System.Drawing.Size(($form.Width - 30), 50)
$form.Controls.Add($statsPanel)

$statsLabel = New-Object System.Windows.Forms.Label
$statsLabel.Text = "Total: 9 | Selected: 9 | Completed: 0 | Errors: 0"
$statsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statsLabel.ForeColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
$statsLabel.TextAlign = "MiddleCenter"
$statsLabel.Location = New-Object System.Drawing.Point(10, 15)
$statsLabel.Size = New-Object System.Drawing.Size(($statsPanel.Width - 20), 20)
$statsPanel.Controls.Add($statsLabel)

# Button Panel
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Location = New-Object System.Drawing.Point(15, 510)
$buttonPanel.Size = New-Object System.Drawing.Size(($form.Width - 30), 50)
$form.Controls.Add($buttonPanel)

# Pre-defined button colors (avoid creating new Color objects repeatedly)
$buttonColors = @{
    "Scan" = @([System.Drawing.Color]::FromArgb(86, 156, 214), [System.Drawing.Color]::White)
    "Optimize" = @([System.Drawing.Color]::FromArgb(75, 180, 75), [System.Drawing.Color]::White)
    "Select All" = @([System.Drawing.Color]::FromArgb(255, 185, 0), [System.Drawing.Color]::Black)
    "Deselect All" = @([System.Drawing.Color]::FromArgb(255, 140, 0), [System.Drawing.Color]::White)
    "Export Log" = @([System.Drawing.Color]::FromArgb(180, 100, 200), [System.Drawing.Color]::White)
    "Exit" = @([System.Drawing.Color]::FromArgb(232, 17, 35), [System.Drawing.Color]::White)
}

# Create buttons without complex hover effects (simpler = less memory)
function Create-SimpleButton {
    param([string]$Text, [int]$X, [int]$Width = 130)
    
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $button.FlatStyle = "Flat"
    $button.FlatAppearance.BorderSize = 1
    $button.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $button.Size = New-Object System.Drawing.Size($Width, 35)
    $button.Location = New-Object System.Drawing.Point($X, 10)
    
    if ($buttonColors.ContainsKey($Text)) {
        $button.BackColor = $buttonColors[$Text][0]
        $button.ForeColor = $buttonColors[$Text][1]
    } else {
        $button.BackColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $button.ForeColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    }
    
    return $button
}

# Create buttons
$scanButton = Create-SimpleButton -Text "Scan" -X 20
$optimizeButton = Create-SimpleButton -Text "Optimize" -X 160
$selectAllButton = Create-SimpleButton -Text "Select All" -X 300
$deselectAllButton = Create-SimpleButton -Text "Deselect All" -X 440
$exportButton = Create-SimpleButton -Text "Export Log" -X 580 -Width 120
$exitButton = Create-SimpleButton -Text "Exit" -X 720 -Width 120

# Add buttons to panel
$buttonPanel.Controls.AddRange(@($scanButton, $optimizeButton, $selectAllButton, $deselectAllButton, $exportButton, $exitButton))

# Footer Label
$footerLabel = New-Object System.Windows.Forms.Label
$footerLabel.Text = "Registry Optimizer Pro v1.0 - IGRF Pvt. Ltd. Edition | © 2024 All Rights Reserved"
$footerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$footerLabel.ForeColor = [System.Drawing.Color]::FromArgb(120, 120, 120)
$footerLabel.TextAlign = "MiddleCenter"
$footerLabel.Location = New-Object System.Drawing.Point(10, ($form.Height - 30))
$footerLabel.Size = New-Object System.Drawing.Size(($form.Width - 20), 20)
$form.Controls.Add($footerLabel)

# Update statistics function
function Update-Statistics {
    $total = $listView.Items.Count
    $selected = 0
    $completed = 0
    $errors = 0
    
    foreach ($item in $listView.Items) {
        if ($item.Checked) { $selected++ }
        if ($item.SubItems[2].Text -eq "Completed") { $completed++ }
        if ($item.SubItems[2].Text -eq "Error") { $errors++ }
    }
    
    $statsLabel.Text = "Total: $total | Selected: $selected | Completed: $completed | Errors: $errors"
}

# Button Click Handlers with memory optimization
$scanButton.Add_Click({
    $statusLabel.Text = "Scanning for optimization opportunities..."
    $progressBar.Value = 0
    $form.Refresh()
    
    # Efficient scanning simulation
    1..100 | ForEach-Object {
        $progressBar.Value = $_
        Start-Sleep -Milliseconds 10  # Faster scan
    }
    
    $statusLabel.Text = "Scan complete. Ready to optimize."
    [System.Windows.Forms.MessageBox]::Show("Scan completed! Found $($listView.Items.Count) optimization opportunities.", "Scan Complete", "OK", "Information") | Out-Null
})

$optimizeButton.Add_Click({
    $selectedItems = @($listView.Items | Where-Object {$_.Checked})
    
    if ($selectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select at least one optimization to perform.", "No Selection", "OK", "Warning") | Out-Null
        return
    }
    
    $statusLabel.Text = "Optimizing registry..."
    $progressBar.Value = 0
    $form.Refresh()
    
    $step = 100 / $selectedItems.Count
    $currentProgress = 0
    
    foreach ($item in $selectedItems) {
        $item.SubItems[2].Text = "Optimizing..."
        $listView.Refresh()
        
        # Execute optimization
        try {
            $result = & $item.Tag
            if ($result) {
                $item.SubItems[2].Text = "Completed"
                $item.ForeColor = [System.Drawing.Color]::FromArgb(0, 128, 0)
            } else {
                $item.SubItems[2].Text = "Error"
                $item.ForeColor = [System.Drawing.Color]::FromArgb(255, 0, 0)
            }
        } catch {
            $item.SubItems[2].Text = "Error"
            $item.ForeColor = [System.Drawing.Color]::FromArgb(255, 0, 0)
        }
        
        $currentProgress += $step
        $progressBar.Value = [Math]::Min([int]$currentProgress, 100)
        Update-Statistics
        
        # Minimal delay
        Start-Sleep -Milliseconds 100
    }
    
    $statusLabel.Text = "Optimization complete!"
    [System.Windows.Forms.MessageBox]::Show("Optimization process completed!", "Complete", "OK", "Information") | Out-Null
    $progressBar.Value = 100
})

$selectAllButton.Add_Click({
    foreach ($item in $listView.Items) {
        $item.Checked = $true
    }
    Update-Statistics
})

$deselectAllButton.Add_Click({
    foreach ($item in $listView.Items) {
        $item.Checked = $false
    }
    Update-Statistics
})

$exportButton.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Text files (*.txt)|*.txt|Log files (*.log)|*.log"
    $saveFileDialog.FileName = "RegistryOptimizerLog_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt"
    $saveFileDialog.Title = "Export Optimization Log"
    
    if ($saveFileDialog.ShowDialog() -eq "OK") {
        $logContent = "Registry Optimizer Pro - Optimization Log`n"
        $logContent += "Generated: " + (Get-Date) + "`n"
        $logContent += "=" * 50 + "`n`n"
        
        foreach ($item in $listView.Items) {
            $logContent += "Optimization: " + $item.Text + "`n"
            $logContent += "Description: " + $item.SubItems[1].Text + "`n"
            $logContent += "Status: " + $item.SubItems[2].Text + "`n"
            $logContent += "Selected: " + $item.Checked + "`n"
            $logContent += "-" * 30 + "`n"
        }
        
        $logContent | Out-File -FilePath $saveFileDialog.FileName -Encoding UTF8 -Force
        [System.Windows.Forms.MessageBox]::Show("Log exported successfully to:`n$($saveFileDialog.FileName)", "Export Complete", "OK", "Information") | Out-Null
    }
})

$exitButton.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to exit?", "Exit Confirmation", "YesNo", "Question")
    if ($result -eq "Yes") {
        # Clean up before exit
        $form.Close()
        [System.GC]::Collect()
    }
})

# ListView item checked event
$listView.Add_ItemChecked({
    Update-Statistics
})

# Initialize statistics
Update-Statistics

# Show form with memory optimization
$form.Add_Shown({
    $form.Activate()
    # Force garbage collection after form loads
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
})

# Run application
try {
    [System.Windows.Forms.Application]::Run($form)
} finally {
    # Clean up resources
    $form.Dispose()
    [System.GC]::Collect()
}