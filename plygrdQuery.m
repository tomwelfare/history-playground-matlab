function cleanResponse = plygrdQuery(queries, datasets, authToken)
%PLYGRDQUERY Query the History Playground for the given terms in the
%specified datasets.
%
%   response = PLYGRDQUERY(queries,datasets,authToken) returns a
%   response structure containing each of the time series from the History
%   Playground. The structure for each series can be found in response(1),
%   response(2), etc.
%
%   Example:
%       authToken = plygrdLogin('email','password');
%       queries = {'dog','cat','bird'};
%       datasets = {'bna','caa'};
%       response = plygrdQuery(queries,datasets,authToken);
%       plygrdPlot(response);
%
%    See also PLYGRD, PLYGRDLOGIN, PLYGRDPLOT

url = 'http://playground.enm.bris.ac.uk/ngram';
header = weboptions(...
    'MediaType','application/json',...
    'HeaderFields',{
        'Authorization' authToken;...
        'Content-Type' 'application/json; charset=UTF-8'...
    }...
);

data = struct();
data.changepoints = 0;
data.multiterm = 0;
data.zscore = 0;
data.diff = 0;
data.detrend = 0;
data.bestFit = 0;
data.confidence = 0;
data.smooth = 0;
data.display = {'rank'};
data.maxDate = '';
data.minDate = '';
data.lang = cell(size(datasets,2),1);
data.dateFormat = cell(size(datasets,2),1);
data.interval = cell(size(datasets,2),1);
data.resolution = cell(size(datasets,2),1);
data.terms = cell(size(datasets,2)*size(queries,2),1);
idx = 1;
for i = 1: size(datasets,2)
    data.lang{i,1} = "english";
    data.dateFormat{i,1} = "YYYY";
    data.interval{i,1} = "1";
    data.resolution{i,1} = "years";
    for j = 1 : size(queries,2)
        data.terms{idx,1} = strcat(strcat(queries{1,j},':'),datasets{1,i});
        idx = idx+1;
    end
end
data.corpora = datasets;

% Send the query
response = webwrite(url,data, header);

% Clean up the response // not needed for Matlab
response = rmfield(response, 'orig');
response = rmfield(response, 'dateFormat');
response = rmfield(response, 'interval');
response = rmfield(response, 'lang');
response = rmfield(response, 'resolution');

switch data.display{1}
    case 'counts'
        response = rmfield(response,'rank');
    case 'rank'
        response = rmfield(response,'counts');
end

cleanResponse = response;

end



