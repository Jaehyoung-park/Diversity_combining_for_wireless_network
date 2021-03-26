function [CRC_value] = CRC_code(orig_message)

messageLength = 11520; 
divisorDegree = 15;
message = uint8([orig_message zeros(1,divisorDegree)]);
divisor = uint8(ones(1,divisorDegree+1));


for k = 1:messageLength
    if message(k)
        remainder = bitxor(message(k:k+divisorDegree),divisor)
        message(k:k+divisorDegree) = remainder        
    end    
end

CRC_value = message(messageLength+1:length(message));

end