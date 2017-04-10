classdef C_params < matlab.mixin.Copyable
  %C_PARAMS 
  % a class to store parameters and their values
  % we also store the current value and we can increase it
  % 
  % added tags, so we can compare only items with a tag
  % 
  % todo:
  % -add error to tables
  % -we could add range parameters, where we only store min & max
  %
  % Kuhnke Jan.2016
  %
  
  properties
    sDate
    sName
    cNames
    cErrors
    cTags  
    cParams %is a varArray (rows are params, cols are values)
    cParamsPosition % which param is selected
    other % here we can add anything to the class
  end
  
  methods
    function obj = C_params(name)
      obj.sName = name;
    end
    % check if two classes of params are the same
    % if we add a tag, only objects with a certain tag will be compared
    % 
    function isSame= isTheSameAs(obj,otherobj,tag)
      isSame = 0;
      len1 = obj.getParamLength();
      len2 = otherobj.getParamLength();
      if(len1 ~= len2)
         disp('CParam objects have different lengths');
        return;
      end
      if(nargin > 2)
        %% we use tags!
        for i=1:len1
          t1=obj.cTags{i};
          t2=obj.cTags{i};
          n1=obj.cNames{i};
          n2=otherobj.cNames{i};
          if(strcmp(t1,t2) ~= 1)
              disp('tag names are not the same');
              return;
          end
          if(strcmp(t1,tag) == 1)
            if(strcmp(n1,n2) ~= 1)
              disp('parameter names are not the same');
              disp(n1); disp(n2);
              return;
            end
            if(obj.getPostionFromName(n1) ~= otherobj.getPostionFromName(n2))
              disp('paramter positions are not the same');
              return;
            end
            if(obj.getParam(n1) ~= otherobj.getParam(n2))
              disp('parameter values are not the same');
              return;
            end
          end
        end
      else
        %% else : we don't use tags
        for i=1:len1
          n1=obj.cNames{i};
          n2=otherobj.cNames{i};
          if(strcmp(n1,n2) ~= 1)
            disp('parameter names are not the same');
            disp(n1);disp(n2);
            return;
          end
          if(obj.getPostionFromName(n1) ~= otherobj.getPostionFromName(n2))
            disp('paramter positions are not the same');
            return;
          end
          if(obj.getParam(n1) ~= otherobj.getParam(n2))
            disp('parameter values are not the same');
            return;
          end
        end
      end % if else for tags
      isSame=1;
    end     
    
    function obj=addParam(obj,name, values, tag)
      
      %tagging
      if(nargin < 4)
        tag = 'nt'; %no tag
      end
      
      %check if name already exists
      pp = getPostionFromName(obj,name);
      if(pp ~= 0)
        error('error parameter already exists');
      else
        len =getParamLength(obj);
        %add name
        obj.cNames{len+1} = name;
        %add tag
        obj.cTags{len+1} = tag;
        %
        obj.cParamsPosition{len+1} = 1; 
        
        %check values
        if(iscell(values) == 1)
            cValues = values;
        else
          if(ischar(values) == 1)
            cValues=cell(1);
            cValues{1} = values;
          else  
            cValues = num2cell(values);
          end
          
        end
          obj.cParams{len+1} = cValues;
      end
    end

    function len =getParamLength(obj)
      len = length(obj.cNames);
      
    end
    function len =getParamValueLength(obj,name)
      pp = getPostionFromName(obj,name);
      len = length(obj.cParams{pp});
      
    end
    
    function param= getParam(obj,name, position)

      %get cell position from name
      pp = getPostionFromName(obj,name);
      %get parameter value with position
      if(nargin < 3)
        param = obj.cParams{pp}{obj.cParamsPosition{pp}};
      else
        param = obj.cParams{pp}{position};
      end
    end
    
    function changeParam(obj,name,newval)
      %get cell position from name
      pp = getPostionFromName(obj,name);
      %get parameter value with position
      obj.cParams{pp}{obj.cParamsPosition{pp}} = newval;
    end
        
    function errorParam(obj,errorStr)

      %get cell position from name
      errorPos= max(length(obj.cErrors),1);
      obj.cErrors{errorPos} = errorStr;


    end
    
    function position = getPostionFromName(obj,name)
      for i=1:size(obj.cNames,2)
        if(strcmp(name, obj.cNames{i}) == 1)
          position = i;
          return;
        end
      end
      position=0;
      %disp(['no param named like "' name '" found...']);
      return;
    end
    
    
    
    function [isDone,obj] = nextCombination(obj)
        len =getParamLength(obj);
        isDone = 1;
        for i=1:len
          len = getParamValueLength(obj,obj.cNames{i});
          pos = obj.cParamsPosition{i};
          if(pos < len)
            obj.cParamsPosition{i} = obj.cParamsPosition{i}+1;   
            isDone = 0;
            fprintf([obj.cNames{i} ' : ']); 
            disp(obj.cParams{i}{obj.cParamsPosition{i}});
            return;
          else
            obj.cParamsPosition{i} = 1;               
          end        
        end
        disp('done, no next parameter combination');
    end
    
    function cCP = currentParams(obj)
      len1 = obj.getParamLength();
      cCP = cell(1,len1);
      disp('does not work for cellarray params yet? no only if they are like {{input,input}}, {in,in} is fine');
      for i = 1:len1
           cCP{1,i} = obj.getParam(obj.cNames{i});
      end
    end
    
    function storeTXT(obj)
      % save a txt file of all parameters with timestamp
      T = cell2table(obj.cParams,'VariableNames',obj.cNames);
      writetable(T,['Table_' obj.sName '_' obj.sDate '.txt']);
    end
    
    function storeTableCurrent(obj,whereToStore)
      % save a txt file of all parameters with timestamp
      tak = obj.currentParams();
      T = cell2table(tak,'VariableNames',obj.cNames);
      writetable(T,[whereToStore '/Table_' obj.sName '_' obj.sDate '.txt']);
    end
    
    
    function T= returnTable(obj)      
      T = cell2table(obj.currentParams(),'VariableNames',obj.cNames);
      iter = obj.nextCombination();
      tableIdx=2;
      while(iter == 0)
        T(tableIdx,:) = cell2table(obj.currentParams());
        iter = obj.nextCombination();  
        tableIdx=tableIdx+1;
      end
    end
    
  end
  
end

