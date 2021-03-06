classdef State < handle
% The unit in AES alforithm
properties (SetObservable, AbortSet)
%     origin
    hexrow  % [1x32] char array (No space, here I add spaces just to make it clear.)
            %        '448ff4f8eae2cea393553e15fd00eca1'
            %        '44 8f f4 f8  ea e2 ce a3  93 55 3e 15  fd 00 ec a1'
    hexmat  % [4x4] or [1x16] or ...  chars(1x2) cell (Column-wise, do not forget this!): 
            %        {'44', 'ea', '93','fd'; '8f','e2', ...}
%     binstr  % [4x4] or [1x16] or ...  chars(1x8) cell
%             %        {'01000100','11101010', ... }
%     binvec  % [4x4] [1x16] ... double array(1x8) cell
%             %        {[1 0 1 0 0 0 0 1], [1 1 1 0 1 0 1 0], ...}
%     dec     % [4x4]  double array cell/array
%             %        {  68, 234, 147, 253; 143, 226, ...}
    norm = cell(4,4);
    % [4x4] Byte cell
    %       {Byte('44'), ... ; Byte('8f'), ... }

% There is no need to initialize these formats of state at the creation,
%   and just convert their types when we need.
% But it seems that the initialization of formats does not take much time
%   compared to other operations,
%   and all of the formats above are useful in the algorithm
% So I tend to intialize these formats at the beginning.

% Look, it is necessary to abstract the each byte in the State to a new clas!
% Since the size is always [4x4] cell, 
%   what we need to change is just the type of each byte.

% What we always get at the beginning is the 'hexrow' type,
%   so I just write the 'hexrow' to 'hex' function 'hexrow2hex' 
%   and 'hex' to others functions like 'hex2binstr'
% It is better to convert the type of each byte in Byte's methods,
%   instead of converting them at the State's methods.
% In State's methods we just need to use a for loop (cellfun is slow)
%   to call the convert funciton in the Byte's methods.

end

methods
    function obj = State(varargin)
        if isempty(varargin)
            obj.addListeners;
            return ;
        else
            statein = varargin{1};
        end
        
        changedProp = obj.initialize(statein);
        obj.typeConversion(changedProp);
        obj.addListeners;
    end

end

methods
   changedProp = initialize(obj,statein); 
   typeConversion(obj,varargin);
   addListeners(obj);
end

methods
    function hexrow2norm(obj)
        normcell = cell(4,4);
        for i = 1:16
           byte = obj.hexrow(1,2*i-1:2*i);
           normcell{i} = aes.Byte(byte);
        end
        obj.norm = normcell;
    end
    function hexmat2norm(obj)
        normcell = cell(4,4);
        for i = 1:16
            byte = obj.hexmat{i};
            normcell{i} = aes.Byte(byte);
        end
        obj.norm = normcell;
    end
    
    function norm2hexrow(obj)
        for i = 1:16
            hexrow_tmp(1,2*i-1:2*i) = obj.norm{i}.hex(1,1:2);
        end
        obj.hexrow = hexrow_tmp;
        % Why I use a tmp here?
        % Because matlab will change the value of 'char' to 'double'
        %   in the inter assignments through classes.
        % So I need to assing the whole string together to the obj.hexrow
    end
    function norm2hexmat(obj)
       hexmat_tmp = cell(4,4);
       for i = 1:16
           hexmat_tmp{i} = obj.norm{i}.hex;
       end
       obj.hexmat = hexmat_tmp;
    end
    
end


methods
    varargout = addRoundKey(obj,roundkey,varargin);
    varargout = subBytes(obj,varargin);
    varargout = shiftRows(obj,varargin);
    varargout = mixColumns(obj,varargin);
    varargout = returnNewobj(obj,varargin);
end



end