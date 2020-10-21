%% SpectrumMask
% 
%  Multiply the input spectrum with the selected filter mask
% 
function SpectrumMask(block)

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
block.InputPort(1).DatatypeID  = 0; %double
block.InputPort(1).Complexity  = 'Complex';
block.InputPort(1).DimensionsMode = 'Variable';

% Override output port properties
block.OutputPort(1).DatatypeID  = 0; %double
block.OutputPort(1).Complexity  = 'Complex';
block.OutputPort(1).DimensionsMode = 'Variable';
block.OutputPort(1).Dimensions = [1000,1000];
    
% Override parameters properties
block.NumDialogPrms     = 2;
block.DialogPrmsTunable = {'Nontunable','Nontunable'};

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

filtertype = block.DialogPrm(1).Data;
radius = block.DialogPrm(2).Data;
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

filtertype = block.DialogPrm(1).Data;
radius = block.DialogPrm(2).Data;
sigVal     = block.InputPort(1).Data;

x = (size(sigVal,2)+1)/2;
y = (size(sigVal,1)+1)/2;
[X,Y] = meshgrid([1:size(sigVal,2)],[1:size(sigVal,1)]);

switch radius
    case 1
        R=10;
    case 2
        R=25;
    case 3
        R=50;
end

switch filtertype
    case 1 
        %LPF;
        Out = (sqrt((X-x).^2 + (Y-y).^2) < R);
    case 2 
        %HPF
        Out = (sqrt((X-x).^2 + (Y-y).^2) >= R);
end
% sigVal = fftshift(sigVal);
Out = sigVal.*Out;
% Out = ifftshift(Out);
block.OutputPort(1).CurrentDimensions = size(Out);
block.OutputPort(1).Data = complex(Out);
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction