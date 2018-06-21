function [series dates] = plygrdPlot(response)
%PLYGRDPLOT Plot a time series returned from the History Playground.
%
%   [series dates] = PLYGRDPLOT(response) returns two arrays containing
%   the values and dates for a time series extracted from the input 
%   response structure.
%
%   Example:
%       authToken = plygrdLogin('email','password');
%       queries = {'dog','cat','bird'};
%       datasets = {'bna','caa'};
%       response = plygrdQuery(queries,datasets,authToken);
%       plygrdPlot(response);
%
%    See also PLYGRD, PLYGRDLOGIN, PLYGRDQUERY

    numSeries = size(response,1);
    
    figure; hold on;
    for i = 1 : numSeries % Each query
        data = chooseDisplay(response(i));      
        years = fieldnames(data);
        series(i,:) = zeros(size(years,1),1);
        
        for j = 1:size(years,1) % Each value
            field = years(j);
            dates(j) = datetime(extractAfter(field{1},'x'),'InputFormat','y');
            series(i,j) = getValue(data,field); 
        end

        plot(dates,series(i,:),'LineWidth',1);
    end
    
    setFigureDetails(response);
    hold off;
end

function data = chooseDisplay(response)
    if isfield(response, 'counts')
           data = response.counts;
    else
           data = response.rank;
    end
end

function value = getValue(data, field) 
    if ~isempty(eval(['data.' field{1}]))
        value = eval(['data.' field{1}]);
    else
        value = NaN;
    end
end

function setFigureDetails(response)
    % Set y label
    if isfield(response(1), 'counts'); ylabel('Relative Frequency');
    else; ylabel('Word Rank Score'); end
    
    % Set x label
    xlabel('Year');
    
    % Set legend details
    for i = 1 : size(response,1)
       labels{i} = [response(i).term ' (' response(i).corpus ')']; 
    end
    legend(labels,'Location', 'Best');
    
    % Turn on box
    box on;
end

