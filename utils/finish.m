function finish(params)

if exist('params', 'var')
    for iFile = params.openFileIds
        fclose(iFile);
    end       
    
    fprintf(params.log.fileId, '\n');
end

% clear functions;

end