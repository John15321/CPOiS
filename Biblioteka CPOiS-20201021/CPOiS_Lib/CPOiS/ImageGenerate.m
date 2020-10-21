%% ImageGenerate
% 
%  Generate image from expression with specified dimmensions
% 
function ImageGenerate(block)

setup(block);
%endfunction

%% Function: setup
function setup(block)

% Register original number of ports based on settings in Mask Dialog
block.NumInputPorts = 0;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompOutPortInfoToDynamic;

% Override output port properties
block.OutputPort(1).DatatypeID  = 3; 
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).DimensionsMode = 'Variable';
block.OutputPort(1).Dimensions = [1000,1000];
block.OutputPort(1).SamplingMode   = 'Sample';

% Override parameters properties
block.NumDialogPrms     = 3;
block.DialogPrmsTunable = {'Tunable','Tunable','NonTunable'};

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
Width      = block.DialogPrm(1).Data;
Height     = block.DialogPrm(2).Data;
Expression = block.DialogPrm(3).Data;

if ~(0==(Width-fix(Width)))
    error('Enter an integer value');
end

if Width<=0
    error('Enter positive value');
end

if ~(0==(Height-fix(Height)))
    error('Enter an integer value');
end

if Height<=0
    error('Enter positive value');
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
Width      = block.DialogPrm(1).Data;
Height     = block.DialogPrm(2).Data;
Expression = block.DialogPrm(3).Data;

[W,H] = meshgrid(1:Width,1:Height);

block.OutputPort(1).CurrentDimensions = size(W);
im = eval(Expression);
im = uint8(im);
block.OutputPort(1).Data = im;
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction