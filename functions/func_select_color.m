function C = func_select_color(num,type)

    switch type
        case 'jet'
            colors = jet;
        case 'turbo'
            colors = turbo;
    end
    if num > 1
        stp = floor(256/(num-1));

        C = colors((0:stp:stp*(num-1))+1,:);

    else
        error('number should be integer larger than 1')
    end
end