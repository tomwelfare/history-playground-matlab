%PLYGRD History Playground interface for MATLAB.
%
%   Search the History Playground for n-gram trends (up to a length of 3)
%   in historical newspaper datasets. For more details, please visit
%   http://playground.enm.bris.ac.uk or direct enquiries to
%   tom.welfare@gmail.com
%
%   Currently available datasets:
%       bna - British Newspaper Archive (1800-1950)
%       caa - Chronicling America Archive (1836-1922)
%
%   See also PLYGRDLOGIN, PLYGRDQUERY, PLYGRDPLOT

disp('Welcome to the History Playground.');

% Request login details if they haven't logged in already
if ~exist('authToken','var')
    title = 'Login to History Playground';
    prompt = {'Please enter your email address:',...
        'Please enter your password:'};
    answer = inputdlg(prompt,title);
    clear title prompt;
    if isempty(answer{1}) || isempty(answer{2})
        clear answer;
        return
    end
    authToken = plygrdLogin(answer{1},answer{2});
    clear answer;
    disp('Thank you, you have successfully logged in!');
end

%Request query and dataset options
prompt = 'Please enter your query terms (comma-separated): ';
queryStr = input(prompt,'s');
if isempty(queryStr)
    disp('No queries specified!');
    clear queryStr prompt;
    return
end
queries = strsplit(queryStr,{', ',','});
clear queryStr;

prompt = 'Please enter your chosen datasets [bna, caa] (comma-separated): ';
datasetStr = input(prompt,'s');
if isempty(datasetStr)
    disp('No datasets specified!');
    clear datasetStr prompt;
    return
end

datasets = strsplit(datasetStr,{', ',','});
clear datasetStr;

%Check corpora exist!
acceptable = {'bna', 'caa'};
accept = strcmp(datasets,acceptable);
clear acceptable;
if sum(accept) < size(datasets,2)
    disp('Invalid dataset selected');
    clear accept;
    return;
end

data = plygrdQuery(queries,datasets,authToken);

clear title prompt datasetStr queryStr acceptable accept queries datasets;

% Plot the results
fprintf('Generating plot...');
plygrdPlot(data);
fprintf('Finished\n');
clear ans;

return;