my %RunApache = (
    label       => "Apache - Run Apache",
    procedure   => "RunApache",
    description => "Start/Stop an Apache server",
    category    => "Application Server"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/@PLUGIN_KEY@ - RunApache");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/@PLUGIN_KEY@ - UndeployApp");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/@PLUGIN_KEY@ - DeployApp");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/@PLUGIN_KEY@ - ApplicationManagement");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Apache - Run Apache");

@::createStepPickerSteps = (\%RunApache);
