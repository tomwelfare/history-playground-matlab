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
    try
        authToken = requestLogin();
    catch
        fprintf('Email and/or password are incorrect.\n');
        return
    end
end

%Request query and dataset options
queries = getQueries();
datasets = getDatasets();

ok = checkDatasets(datasets);
if ok
    data = plygrdQuery(queries,datasets,authToken);
    plygrdPlot(data);
else
    clear ok datasets queries;
    return;
end

clear ok ans queries datasets;

return;


function authToken = requestLogin()
    [email password] = logindlg('Login to History Playground','Email');
    if isempty(email) || isempty(password)
        clear email password;
        return
    end
    authToken = plygrdLogin(email,password);
    clear email password;
    disp('Thank you, you have successfully logged in!');
end

function queries = getQueries()
    prompt = 'Please enter your query terms (comma-separated): ';
    queryStr = input(prompt,'s');
    if isempty(queryStr)
        disp('No queries specified!');
        return
    end
    queries = strsplit(queryStr,{', ',','});
end

function datasets = getDatasets()
    prompt = 'Please enter your chosen datasets [bna, caa] (comma-separated): ';
    datasetStr = input(prompt,'s');
    if isempty(datasetStr)
        disp('No datasets specified!');
        return
    end

    datasets = strsplit(datasetStr,{', ',','});
end

function ok = checkDatasets(datasets)
    ok = 1;
    acceptable = {'bna', 'caa'};
    for i = 1 : length(datasets)
        accept(i) = sum(strcmp(acceptable,datasets{i}));
    end
    if sum(accept) < size(datasets,2)
        disp('Invalid dataset selected');
        ok = 0;
    end 
end