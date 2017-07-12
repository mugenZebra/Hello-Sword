Le = 1; theta = 15; Lb = 0;H_blade = 15; H_tip = 2; H_hilt = 1;
H_handle = H_blade/2.5;
r_handle_bot = 0.3; r_handle_top = r_handle_bot;
color_blade = "Silver";
txt1 = "Hello Sword"; txt_size1 = 0.2; font1 = "Consolas";
txt2 = "高啟仁鑄"; txt_size2 = 0.2; font2 = "標楷體";

// mid blade
p0 = [0,0];
p1 = p0 + [Le*cos(theta), Le*sin(theta)];
p1m = p0 + [Le*cos(theta), -Le*sin(theta)];
p0p = p0 + [Lb+2*Le*cos(theta), 0];
p1p = p1 + [Lb, 0];
p1pm = p1m + [Lb, 0];

echo(p0=p0, p1=p1);
echo(p0p=p0p, p1p=p1p);

pc = [(p0p[0] - p0[0])/2,(p0p[1] - p0[1])/2,H_tip];
echo(pc=pc);


W_txt = p1-p1m;
//W_txt = W_txt[1];
t1xy = (p1m-p0)*1.5;
t1 = [t1xy[0], t1xy[1], -7];//
echo(t1=t1);

v_r1 = [p0[0]-p1m[0], p0[1]-p1m[1],0];
v_r2 = cross([0,0,1],v_r1);
echo(v_r1=v_r1, v_r2=v_r2);

union(){
    difference() {
        color(color_blade)
        linear_extrude(height=H_blade, center = true, convexity = 4, twist = 0) polygon(points=[p0, p1, p1p, p0p, p1pm, p1m]);
        
        color("Maroon")
        translate([0,0,t1[2]]) // move down the z-axis
        rotate(90, v_r2) // torate around orthogonal vector to edge surface
        rotate(270, v_r1) // rotate around edge vector
        rotate([0,0,atan((p0[1]-p1m[1])/(p0[0]-p1m[0]))]) // rotate around z axis
        translate([t1[0],t1[1],-0.1]) { // -0.1 is the depth of text embedded in the blade
            linear_extrude(height=W_txt[1], convexity=4)
                text(txt1, font = font1,
                     size=txt_size1,
                     halign="center",
                     valign="center");
        }
        
        color("Maroon")
        translate([0,0,t1[2]]) // move down the z-axis
        rotate(90, v_r2) // torate around orthogonal vector to edge surface
        rotate(270, v_r1) // rotate around edge vector
        rotate([0,0,atan((p0[1]-p1m[1])/(p0[0]-p1m[0]))]) // rotate around z axis
        translate([t1[0]*1.5,t1[1]*1.5,-0.1]) { // -0.1 is the depth of text embedded in the blade
            linear_extrude(height=W_txt[1], convexity=4)
                text(txt2, font = font2,
                     size=txt_size2,
                     halign="center",
                     valign="center");
        }
    }


    // sharp point
    color(color_blade)
    translate([0,0,H_blade/2]) 
    polyhedron(points=[p0, p1, p1p, p0p, p1pm, p1m, pc], 
               faces=[[6,0,1],[6,1,2],[6,2,3],[6,3,4],[6,4,5],[6,5,0]]);

    // hilt
    W_hilt = [p0p[0]-p0[0], p1[1]-p1m[1]];
    echo(W_hilt=W_hilt);
    
    translate([pc[0],pc[1],-H_blade/2])
    scale([1.3, 1.3])
    linear_extrude(height=H_hilt, convexity=4)
    square(size = W_hilt, center = true);


    // handle
    color("Peru")
    translate([pc[0],pc[1],-H_blade/2-H_handle])
    scale([1.5,.8])
    cylinder(h = H_handle, r1 = r_handle_bot, r2 = r_handle_top, center=false, $fn=360);
}
echo(version=version());