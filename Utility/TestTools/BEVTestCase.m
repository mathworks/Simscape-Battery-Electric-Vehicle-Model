classdef BEVTestCase < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function cleanModels(testCase)
            bdclose all;
            testCase.addTeardown(@bdclose,"all");
        end
        function cleanFigures(testCase)
            close all;
            testCase.addTeardown(@close,"all");
        end
    end
end