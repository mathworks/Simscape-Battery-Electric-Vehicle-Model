var sourceData4 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\BEV\\SimulationCases\\BEV_simulationCase_Constant_Thermal.mlx","RawFileContents":["modelName = \"BEV_system_model\";","load_system(modelName)","% Use thermal-model-enabled components.","BEV_useComponents_Thermal","VehSpdRef_loadSimulationCase_Constant( ...","  ModelName = modelName, ...","  TargetSubsystemPath = ...","    \"/Controller & Environment\" + ...","    \"/Vehicle speed reference\" )","simOut = sim(modelName);","simData = extractTimetable(simOut.logsout);","fig = BEV_plotResultsCompact( SimData = simData );"],"CoverageDisplayDataPerLine":{"Function":[],"Statement":[{"LineNumber":1,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":31,"ContinuedLine":false},{"LineNumber":2,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":22,"ContinuedLine":false},{"LineNumber":4,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":25,"ContinuedLine":false},{"LineNumber":5,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":38,"ContinuedLine":false},{"LineNumber":6,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":23,"ContinuedLine":true},{"LineNumber":7,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":23,"ContinuedLine":true},{"LineNumber":8,"Hits":1,"StartColumnNumbers":4,"EndColumnNumbers":33,"ContinuedLine":true},{"LineNumber":9,"Hits":1,"StartColumnNumbers":4,"EndColumnNumbers":32,"ContinuedLine":true},{"LineNumber":10,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":24,"ContinuedLine":false},{"LineNumber":11,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":43,"ContinuedLine":false},{"LineNumber":12,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":50,"ContinuedLine":false}]}}