function EYE = copyevents(EYE, eventLog, offsetParams, eventsToAttach, namesToAttach)

for typeIdx = 1:numel(eventsToAttach)
    matchIdx = strcmpi({eventLog.event.type}, eventsToAttach(typeIdx));
    times = [reshape([eventLog.event(matchIdx).time], [], 1) ones([nnz(matchIdx) 1])]*offsetParams;
    EYE.event = cat(2, reshape(EYE.event, 1, []),...
        reshape(struct(...
            'type', namesToAttach(typeIdx),...
            'time', num2cell(times),...
            'latency', num2cell(round(times/EYE.srate + 1))),...
        1, []));
end

[~, I] = sort([EYE.event.time]);
EYE.event = EYE.event(I);

end