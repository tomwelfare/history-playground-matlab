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
    y = '';
    figure;
    hold on;
    for i = 1 : numSeries
        if isfield(response(i), 'counts')
           data = response(i).counts;
           y = 'Relative Frequency';
        else
           data = response(i).rank;
           y = 'Word Rank Score';
        end
        years = fieldnames(data);
        series(i,:) = zeros(size(years,1),1);
        for j = 1:size(years,1)
            field = years(j);
            dates(j) = datetime(extractAfter(field{1},'x'),'InputFormat','y');
            if ~isempty(eval(['data.' field{1}]))
                series(i,j) = eval(['data.' field{1}]);
            else
                series(i,j) = NaN;
            end
        end

        plot(dates,series(i,:),'LineWidth',1);
        ylabel(y);
        xlabel('Year');    
        labels{i} = [response(i).term ' (' response(i).corpus ')'];
    end
    legend(labels,'Location', 'Best');
    box on;
    hold off;
end

