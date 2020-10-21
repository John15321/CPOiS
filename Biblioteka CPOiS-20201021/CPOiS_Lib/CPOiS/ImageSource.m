%% ImageSource
% 
%  Load image from selected file
% 
function ImageSource(block)

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
block.OutputPort(1).DatatypeID  = 3; %uint8
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode   = 'Sample';
block.OutputPort(1).DimensionsMode = 'Variable';
block.OutputPort(1).Dimensions = [1000,1000];

% Override parameters properties
block.NumDialogPrms     = 1;
block.DialogPrmsTunable = {'NonTunable'};

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

FileSelection = block.DialogPrm(1).Data;
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

FileSelection = block.DialogPrm(1).Data;

FileName = get(gcbh,'FileSelection');

im = imread(FileName);
dim = size(im);

%convert to grayscale
if size(im,3) == 3
    im = rgb2gray(im);
end

%resolution reduction
if max(dim)>1000
    if find(dim==max(dim)) == 1
        im=imresize(im,[1000, NaN]);
    end
    if find(dim==max(dim)) == 2
        im=imresize(im,[NaN, 1000]);
    end
end

block.OutputPort(1).CurrentDimensions = size(im);
im = im2uint8(im);
block.OutputPort(1).Data = im;
%endfunction

%% Function: Terminate
function Terminate(block)
%endfunction