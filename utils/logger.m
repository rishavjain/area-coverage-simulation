function logger( params, logLevel, logStr )

fStack = dbstack;

if params.log.level <= logLevel
    if logLevel == 1
        levelStr = 'DEBUG';
    elseif logLevel == 2
        levelStr = 'INFO';
    else
        levelStr = 'ERROR';
    end
    
    fprintf(params.log.fileId, '[%s, %s, %3d, %5s] %s\n', datestr(datetime), fStack(2).name, fStack(2).line, levelStr, logStr);
end

end
