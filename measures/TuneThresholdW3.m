function threshold = TuneThresholdW3(train_data, train_target, model)
    Outputs_tr = train_data * model.w;
    [threshold,  ~] = TuneThreshold( Outputs_tr', train_target, 1, 1);
end