%% ImageHistogram
% 
%  Computes and plots the image histogram
% 
function ImageHistogram(block)

setup(block);
%endfunction

%% Function: setup
function setup(block)

% Register original number of ports based on settings in Mask Dialog
block.NumInputPorts = 1;
block.NumOutputPorts = 0;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;

% Override input port properties
block.InputPort(1).DatatypeID  = 3; 
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DimensionsMode = 'Variable';

% Override parameters properties
block.NumDialogPrms     = 0;

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

sigVal     = block.InputPort(1).Data;
h=figure;
h.Name = ['Histogram - ',get(block.BlockHandle,'Name')];
imhist(sigVal); axis tight; 
f=get(gcf,'Children');
set(f(1),'XTick',[0,31+[0:32:256]]);
set(f(2),'XTick',[0:255]);
set(get(f(2),'Children'),'LineWidth',3);
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction