$modules = Get-ChildItem -Path '<FullPath>\CARML\ResourceModules\modules' -Recurse -Filter 'deploy.bicep'

$modules.FullName | ForEach-Object -Parallel {
    . '<FullPath>\CARML\ResourceModules\utilities\pipelines\resourcePublish\Publish-ModuleToPrivateBicepRegistry.ps1'
    Publish-ModuleToPrivateBicepRegistry -TemplateFilePath $_ -ModuleVersion '<version>' -BicepRegistryName '<brName>' -BicepRegistryRgName '<rgName>'
} -ThrottleLimit 4
