function outputImage = Obeymajority(inputImage)
    % Ensure input is binary
    inputImage = logical(inputImage);

    % Define the 3x3 kernel for 8-connectivity
    kernel = [1 1 1; 1 0 1; 1 1 1];

    % Compute the sum of neighbors for each pixel
    neighborSum = conv2(inputImage, kernel, 'same');

    % Apply the majority rule
    outputImage = (neighborSum >= 3) | (inputImage & (neighborSum >= 0 & neighborSum < 3));

    % Convert the output to logical
    outputImage = logical(outputImage);
end
