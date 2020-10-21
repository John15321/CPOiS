%% SpectrumViewer
% 
%  Displays the scaled logarithm of  a magnitude of a spectrum
% 
function SpectrumViewer(block)

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
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Complex';
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

Out = log(abs(sigVal)+1);
Out = Out-min(Out(Out>0)); %substract the nonzero minimum
Out(Out<=0)=0; %substitute all negative and zero values with zero
Out = Out/max(max(Out)); % scale to 0-1
h = imtool(im2uint8(Out));
h.Name = ['Image Tool - ',get(block.BlockHandle,'Name')];
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction