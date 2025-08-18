classdef unittest_findLookupTable1DBlocks < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this section always run before each test defined in the Test section runs.

    function test_method_setup_1(testcase)
      function closeAll
        close all
        bdclose all
      end  % nested function
      closeAll
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)
    end  % function

  end  % methods

  methods (Test)

    function ErrorTest_1(testcase)
      verifyError(testcase, @test_target, "Simulink:Commands:OpenSystemUnknownSystem")
      function test_target()
        ModelTool1.findLookupTable1DBlocks("dummy_model_name")
      end  % nested function
    end  % function

    %%

    function PassingTest_1(~)
      load_system("testmodel_findLookupTable1DBlocks_refsub")
      ModelTool1.findLookupTable1DBlocks;  % !test-target
    end  % function

    function PassingTest_2(~)
      load_system("testmodel_findLookupTable1DBlocks_refsub")
      ModelTool1.findLookupTable1DBlocks(gcs);  % !test-target
    end  % function

    function PassingTest_3(~)
      load_system("testmodel_findLookupTable1DBlocks_refsub")
      ModelTool1.findLookupTable1DBlocks(gcs + "/Subsystem");  % !test-target
    end  % function

    function PassingTest_4(~)
      demo_findLookupTable1DBlocks
    end  % function

    %%

    function TestDefault(testcase)
      load_system("testmodel_findLookupTable1DBlocks_refsub")
      blocks = ModelTool1.findLookupTable1DBlocks;  % !test-target

      expected = [
        "testmodel_findLookupTable1DBlocks_refsub/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/PS Lookup Table (1D)1"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem1/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/PWC"
        "testmodel_findLookupTable1DBlocks_refsub/SL smooth1"
        "testmodel_findLookupTable1DBlocks_refsub/SL smooth2"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/1-D Lookup" + newline + "Table"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem/1-D Lookup" + newline + "Table"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem1/1-D Lookup" + newline + "Table"
        ];

      verifyEqual(testcase, blocks, expected)
    end  % function

    function TestSubsystemPath(testcase)
      load_system("testmodel_findLookupTable1DBlocks_refsub")
      blocks = ModelTool1.findLookupTable1DBlocks(gcs + "/Subsystem");  % !test-target

      expected = [
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem1/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/1-D Lookup" + newline + "Table"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem/1-D Lookup" + newline + "Table"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/Subsystem1/1-D Lookup" + newline + "Table"
        ];

      verifyEqual(testcase, blocks, expected)
    end  % function

    function TestSearchDepth(testcase)
      load_system("testmodel_findLookupTable1DBlocks_refsub")
      blocks = ModelTool1.findLookupTable1DBlocks(gcs + "/Subsystem", SearchDepth=1);

      expected = [
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/PS Lookup Table (1D)"
        "testmodel_findLookupTable1DBlocks_refsub/Subsystem/1-D Lookup" + newline + "Table"
        ];

      verifyEqual(testcase, blocks, expected)
    end  % function

  end  % methods

end  % classdef
