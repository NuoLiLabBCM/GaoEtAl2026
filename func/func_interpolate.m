function B = func_interpolate(A, target_len)
%func_interpolate interpolate v to the target length, interpolated value is
%the mean of the values flanking the interpolated site.
B = [];
for i_rows = 1:size(A,1)
    v = A(i_rows,:);
    if target_len >= 2 * length(v)
        error('Target length can not be bigger than double the original length.');
    end
    origin_len = length(v);
    len_to_insert = target_len - origin_len;
    interval = round(origin_len / len_to_insert);
    u = [];
    for i = 1:origin_len

        if mod(i,interval) == 0
            if i == origin_len
                u = [u, v(i - interval + 1:i), v(i)];
            else
                u = [u, v(i - interval + 1:i), 1/2*(v(i) + v(i + 1))];
            end
            len_to_insert = len_to_insert - 1;
        end

        if len_to_insert == 0
            u = [u v(i+1:end)];
            break
        end
    end
    B = [B;u];
end
end