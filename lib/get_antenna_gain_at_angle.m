function gain = get_antenna_gain_at_angle(Bmulti, theta, beamAOD)

% In this code beamAOD cannot be arbitrary decimal valued. 

nbeams = length(beamAOD); %number of enquiry beam angles

for nid = 1:nbeams
    gain(nid) = Bmulti(theta == beamAOD(nid)); %% assume resolution satisfied
end