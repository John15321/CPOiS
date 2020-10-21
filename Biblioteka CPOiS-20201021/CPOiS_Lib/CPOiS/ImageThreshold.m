%% ImageThreshold
% 
%  Binarizes input image with a global threshold from parameter
% 
function ImageThreshold(block)

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
block.InputPort(1).DatatypeID  = 3; %uint8
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DimensionsMode = 'Variable';

% Override output port properties
block.OutputPort(1).DatatypeID  = 3; %uint8 %8; %boolean
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).DimensionsMode = 'Variable';
block.OutputPort(1).Dimensions = [1000,1000];

% Override parameters properties
block.NumDialogPrms     = 1;
block.DialogPrmsTunable = {'Nontunable'};

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
Threshold= block.DialogPrm(1).Data;
% The Threshold value must have an integer value
if ~(0==(Threshold-fix(Threshold)))
    error('Enter an integer value');
end

if Threshold<=0
    error('Enter positive value');
end

if Threshold>255
    error('Enter a lower value');
end
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
Threshold = block.DialogPrm(1).Data;
sigVal    = block.InputPort(1).Data;

block.OutputPort(1).CurrentDimensions = size(sigVal);
block.OutputPort(1).Data = im2uint8(imbinarize(sigVal,Threshold/255));
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction