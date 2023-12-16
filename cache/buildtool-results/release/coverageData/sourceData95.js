var sourceData95 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Components\\MotorDriveUnit\\SimulationCases\\MotorDriveUnit_simulationCase_Drive.mlx","RawFileContents":["mdl = \"MotorDriveUnit_harness_model\";","if not(bdIsLoaded(mdl))","  load_system(mdl)","end","MotorDriveUnit_harness_setup","MotorDriveUnit_useRefsub_Basic","% MotorDriveUnit_useRefsub_BasicThermal","% MotorDriveUnit_useRefsub_System","% MotorDriveUnit_useRefsub_SystemTable","MotorDriveUnit_loadSimulationCase_Drive","simOut = sim(mdl);","simData = extractTimetable(simOut.logsout);","sigNames = [","  \"Motor torque command\"","  \"Axle clutch switch\"","  \"Axle speed input\"","  \"Axle torque input\"","  \"Motor power rate\"","  \"Motor speed\"","  \"Motor temperature\"","  \"Battery power\"","  \"Battery current\"","  \"Battery voltage\"","  ];","for i = 1 : numel(sigNames)","  fig = plotSimulationResultSignal( ...","    SimData = simData, ...","    SignalName = sigNames(i));","  fig.Position(4) = 200;","end"],"CoverageDisplayDataPerLine":{"Function":[],"Statement":[{"LineNumber":1,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":37,"ContinuedLine":false},{"LineNumber":2,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":23,"ContinuedLine":false},{"LineNumber":3,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":18,"ContinuedLine":false},{"LineNumber":5,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":6,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":30,"ContinuedLine":false},{"LineNumber":10,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":39,"ContinuedLine":false},{"LineNumber":11,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":18,"ContinuedLine":false},{"LineNumber":12,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":43,"ContinuedLine":false},{"LineNumber":13,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":12,"ContinuedLine":false},{"LineNumber":14,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":24,"ContinuedLine":true},{"LineNumber":15,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":22,"ContinuedLine":true},{"LineNumber":16,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":20,"ContinuedLine":true},{"LineNumber":17,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":21,"ContinuedLine":true},{"LineNumber":18,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":20,"ContinuedLine":true},{"LineNumber":19,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":15,"ContinuedLine":true},{"LineNumber":20,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":21,"ContinuedLine":true},{"LineNumber":21,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":17,"ContinuedLine":true},{"LineNumber":22,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":19,"ContinuedLine":true},{"LineNumber":23,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":19,"ContinuedLine":true},{"LineNumber":24,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":4,"ContinuedLine":true},{"LineNumber":25,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":27,"ContinuedLine":false},{"LineNumber":26,"Hits":10,"StartColumnNumbers":2,"EndColumnNumbers":35,"ContinuedLine":false},{"LineNumber":27,"Hits":10,"StartColumnNumbers":4,"EndColumnNumbers":21,"ContinuedLine":true},{"LineNumber":28,"Hits":10,"StartColumnNumbers":4,"EndColumnNumbers":30,"ContinuedLine":true},{"LineNumber":29,"Hits":10,"StartColumnNumbers":2,"EndColumnNumbers":24,"ContinuedLine":false}]}}