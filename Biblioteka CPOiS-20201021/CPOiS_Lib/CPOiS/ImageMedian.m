%% ImageMedian
% 
%  Performs median filtering of the input image in two dimensions
% 
function ImageMedian(block)

setup(block);
%endfunction

%% Function: setup
function setup(block)

% Register original number of ports based on settings in Mask Dialog
block.NumInputPorts = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).DatatypeID  = 3;  % uint8
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DimensionsMode = 'Variable';

% Override output port properties
block.OutputPort(1).DatatypeID  = 3; % uint8
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).DimensionsMode = 'Variable';
block.OutputPort(1).Dimensions = [1000,1000];
    
% Override parameters properties
block.NumDialogPrms     = 1;
block.DialogPrmsTunable = {'Tunable'};

% Register sample times [0 offset]
block.SampleTimes = [1 0];

%% Options
% Specify if Accelerator should use TLC or call back into
% M-file
block.SetAccelRunOnTLC(false);

% Register methods called during update diagram/compilation

block.RegBlockMethod('CheckParameters',      @CheckPrms);
block.RegBlockMethod('ProcessParameters',    @ProcessPrms);
block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
block.RegBlockMethod('Outputs',              @Outputs);
block.RegBlockMethod('Terminate',            @Terminate);
%endfunction

%% Function: CheckPrms
function CheckPrms(block)
MaskSize = block.DialogPrm(1).Data;
%endfunction

%% Function: ProcessPrms
function ProcessPrms(block)
% Update run time parameters
block.AutoUpdateRuntimePrms;
%endfunction

%% Function: DoPostPropSetup
function DoPostPropSetup(block)
% Register all tunable parameters as runtime parameters.
block.AutoRegRuntimePrms;
%endfunction

%% Function: Outputs
function Outputs(block)

MaskSize = block.DialogPrm(1).Data;
sigVal   = block.InputPort(1).Data;

switch MaskSize
    case 1
        Dimension=3;
    case 2 
        Dimension=5;
    case 3
        Dimension=7;
end

block.OutputPort(1).CurrentDimensions = size(sigVal);
block.OutputPort(1).Data = uint8(medfilt2(sigVal, [Dimension,Dimension]));
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction