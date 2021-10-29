-- function [xx,yy,n_failures]=RK45_incomplete(f,span,y0,tol)
-- %Adaptive step-size 4/5 order Runge Kutta solver, with tolerance tol. The
-- %code below is incomplete and will not run. It has not implemented the
-- %adaptive step size feature. You must
-- %   1) Make sure you understand every line of the code.
-- %   2) Add in the appropriate commands to make the adaptive step size.
-- %%
-- x0= span(1);
-- x_end = span(2);
-- c = [0   1/4    3/8   12/13 1 1/2];
-- b5 =[16/135 0   6656/12825  28561/56430     -9/50   2/55];
-- b4 =[25/216 0   1408/2565   2197/4104   -1/5 0];
-- A=zeros(6);
-- A(2,1)=1/4;
-- A(3,1:2)=[3/32 9/32];
-- A(4,1:3)=[1932/2197   -7200/2197  7296/2197];
-- A(5,1:4)=[439/216     -8      3680/513    -845/4104];
-- A(6,1:5)=[-8/27   2    -3544/2565     1859/4104   -11/40];
--
-- %ensure that y0 is a column vector
-- y0=y0(:);
--
-- xx=x0; %initialize
-- yy=y0; %initialize
--
-- %Find the direction of propagation
-- if x_end>=x0
--     xdir=1;
-- else
--     xdir=-1;
-- end
--
-- %guess an initial step size
-- h=min([abs(x_end-x0)/10,0.1]); %h is always positive
--
--
-- x=x0;y=y0;
-- done=false;
-- n_failures=0;
-- dimy=numel(y0);
--
-- %Main Loop
-- while ~done
--     minh=16*eps(x);     %minimum acceptable value of h
--     failures=false;     %no step-size failures yet
--
--     %Make sure to hit last step exactly
--     if abs(x_end-x)<=h
--         h=abs(x_end-x);
--         done=true;
--     end
--
--     %Loop for advancing one step
--     while true
--         fn=zeros(6,dimy);
--
--         %Please study these lines carefully. How do they work?
--         for i=1:6
--             fn(i,:)=f(x+xdir*h*c(i),y + xdir*h* (A(i,:)*fn).'  ).';
--         end
--         y5=y+xdir*h*(b5*fn).';
--         y4=y+xdir*h*(b4*fn).';
--
--         err_rel=max(abs((y5-y4)./y5)); %You must fill this in
--
--         if err_rel<tol
--             %accept step and update step size. Do not increase step size by
--             %more than a factor of ten nor reduce it by more than a factor
--             %of 2.
--             x=x+xdir*h;
--             y=y5;
--             xx=[xx,x];
--             yy=[yy,y];
--
--             h=h*0.9*min(10, (tol/(err_rel)).^(1/5)); %you must fill this in (may be more than one command)
--             break
--         else
--             done = false; %fixed bug
--             %reject step. Reduce h (by at most a factor of 2) and try again
--             if ~failures
--                 h=h*0.7*max(0.5/0.7, (tol/(err_rel)).^(1/5));  %you must fill this in (may be more than one command)
--                 failures=true;
--                 n_failures=n_failures+1;
--             else
--                 h=h/2;
--             end
--             h = max(h, minh);
--         end
--
--     end
-- end
local rk45 = {}

function rk45.rk45(f, tol, tspan, y0)

  local x0= tspan[1];
  local x_end = tspan[2];
  local c = {0,   1/4,    3/8,   12/13, 1, 1/2};
  local b5 ={16/135, 0,   6656/12825,  28561/56430,     -9/50,   2/55};
  local b4 ={25/216, 0,   1408/2565,   2197/4104,   -1/5, 0};

  local A = {
      {0, 0, 0, 0, 0, 0},
      {1/4, 0, 0, 0, 0, 0},
      {3/32, 9/32, 0, 0, 0, 0},
      {1932/2197,   -7200/2197,  7296/2197, 0, 0, 0},
      {439/216,     -8,      3680/513,    -845/4104, 0, 0},
      {-8/27,   2,    -3544/2565,     1859/4104,   -11/40, 0},
      }

  local xx=x0; --initialize
  local yy=y0;

  local xdir
  if x_end>=x0
      xdir=1;
  else
      xdir=-1;
  end

  local h= math.min([math.abs(x_end-x0)/10,0.1]);

  local x=x0; local y=y0;
  local done=false;
  local n_failures=0;
  local dimy= numel(y0);

end
