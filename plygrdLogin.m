function token = plygrdLogin(email,password)
%PLYGRDLOGIN Log in to the History Playground and obtain an
%authentication token.
%
%   authToken = PLYGRDLOGIN('email','password') returns an
%   authentication token specific to your details for the History 
%   Playground. Once you have an authentication token, you do not need to 
%   request a new one for each query. Tokens should not be shared between 
%   users or posted online else your login may be revoked.
%
%   Example:
%       authToken = plygrdLogin('email','password'); % only need to
%                                                        % to do this once
%
%       queries = {'dog','cat','bird'};
%       datasets = {'bna','caa'};
%       response = plygrdQuery(queries,datasets,authToken);
%       plygrdPlot(response);
%
%    See also PLYGRD, PLYGRDQUERY, PLYGRDPLOT

url = 'http://playground.enm.bris.ac.uk/auth';
header = weboptions(...
    'MediaType','application/json',...
    'HeaderFields',{
        'Content-Type' 'application/json; charset=UTF-8'...
    }...
);

data.email = email;
data.password = password;
response = webwrite(url,data, header);
token = ['Bearer ' response.token];
end

