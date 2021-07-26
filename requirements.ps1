$mkdocsArgs = @('install','mkdocs','-y',"--source='https://community.chocolatey.org/api/v2'")
& choco @mkdocsArgs

Install-Module PlatyPS -Force