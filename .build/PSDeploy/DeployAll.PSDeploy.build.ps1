Param (
    [io.DirectoryInfo]
    $ProjectPath = (property ProjectPath (Join-Path $PSScriptRoot '../..' -Resolve -ErrorAction SilentlyContinue)),

    [string]
    $BuildOutput = (property BuildOutput 'C:\BuildOutput'),

    [string]
    $ProjectName = (property ProjectName (Split-Path -Leaf (Join-Path $PSScriptRoot '../..')) ),

    [string]
    $PesterOutputFormat = (property PesterOutputFormat 'NUnitXml'),

    [string]
    $APPVEYOR_JOB_ID = $(try {property APPVEYOR_JOB_ID} catch {}),

    $DeploymentTags = $(try {property DeploymentTags} catch {}),

    $DeployConfig = (property DeployConfig 'Deploy.PSDeploy.ps1')
)

task DeployAll {
    $LineSeparation
    "`t`t`t DEPLOYMENT "
    $LineSeparation

    if (![io.path]::IsPathRooted($BuildOutput)) {
        $BuildOutput = Join-Path -Path $ProjectPath.FullName -ChildPath $BuildOutput
    }

    $DeployFile =  [io.path]::Combine($ProjectPath, $DeployConfig)

    
    $InvokePSDeployArgs = @{
        Path = $DeployFile
        Force = $truee
        #DeploymentRoot = $ProjectPath
    }

    if($DeploymentTags) {
        $null = $InvokePSDeployArgs.Add('Tags',$DeploymentTags)
    }

    Import-Module PSDeploy
    Invoke-PSDeploy @InvokePSDeployArgs
}