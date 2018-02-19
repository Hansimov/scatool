import javax.swing.*
import java.awt.*

% js = JSpinner;
% uiinspect(js)
f = figure;
% [jspinner,mspinner] = javacomponent('javax.swing.JSpinner');

fpos = getpixelposition(f);
[jspinner,mspinner] = javacomponent(js);

% https://stackoverflow.com/questions/15880844/how-to-limit-jspinner
sm = SpinnerNumberModel(1.1, 0, 9, 0.3); % default, min, max, step
js = JSpinner(sm);
% mspinner.Parent = f;
% mspinner.Position = [100, 100, 100, 40];
mspinner.Units = 'normalized';

vbox = uix.VButtonBox( 'Parent', f);
vbox.Units = 'normalized';
% vbox.Position = [0.5 0.5 1 1];
vbox.ButtonSize = [60 20];
mspinner.Parent = vbox;


% jspinner.setValue(1.5);
% jspinner.setSize(100,10);
% jspinner.setMinimumSize(Dimension(50,10));
% jspinner.setMaximumSize(Dimension(50,10));

%%
import javax.swing.*
import java.awt.*
f = figure;

fpos = getpixelposition(f);
[jspinner, mspinner] = javacomponent(js);
mspinner.Parent = f;
fpos = getpixelposition(f);
mspinner.Position = [fpos(3)*0.8 fpos(4)*0.8 50 25];

updateSpinnerPostion = [ ...
    'fpos = getpixelposition(f);' newline ...
    'mspinner.Position = [0.8*fpos(3) 0.8*fpos(4) 50 25];'...
    ]; 
% disp(updateSpinnerPostion);
f.ResizeFcn = updateSpinnerPostion;



%%
function updateSpinnerPostion()
    
end