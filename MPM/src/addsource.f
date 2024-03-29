      subroutine addsource(dx,nx,nz,buffer,bx1,bz1,bbx1,bbz1,rotation,
     1     denu,denw,ut,wt,wavex,wavez,dt,xs,zs,source,it,verbose)

c*********************************************************
c xs,zs : ShotPoint in BIG grid
c shotx,shotz : ShotPoint in SMALL Grid
c ixwavemin : minmum x-point of moving box in BIG grid
c izwavemin : minmum z-point of moving box in BIG grid
c
c
c CHECK OUT OF RANGE IF/LOOP
c
c
c*********************************************************
      implicit none
      include 'mpm.inc'

c---------------------------------------------------------------
c     Global variables from Main program
c---------------------------------------------------------------
c     MODEL
      REAL dx
      INTEGER bx1,bz1
      INTEGER bbx1,bbz1

c     MOVING BOX
      INTEGER nx,nz
      INTEGER buffer
      INTEGER wavex(ntmax),wavez(ntmax)
      REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
      REAL ut(nxmax,nzmax), wt(nxmax,nzmax)

c     TIME SAMPLING
      REAL dt

c     SOURCE
      INTEGER xs,zs
      REAL source(ntmax)
      INTEGER rotation
c     IO
      INTEGER verbose

c     MODELING
      INTEGER it      

c---------------------------------------------------------------
c     Local variables
c---------------------------------------------------------------
c     SHOTX,SHOTX is the position of the source in the current grid 
      INTEGER shotx, shotz
      INTEGER outofrange
c     outofrange is '1' when source insertion is outside the grid
      
c     
c     DECLARATIONS FINISHED
c     

c     DEFINE SHOT POSITION IN CURRENT GRID
      shotx=xs-bbx1
      shotz=zs-bbz1

      outofrange=0      

      if (verbose.gt.5) print*, ' SOURCE POS : ',xs,zs,shotx,shotz,zs

      if (shotx.lt.(bx1+1)) outofrange=1
      if (shotx.gt.(bx1+nx))  outofrange=1
      if (shotz.lt.(bz1+1)) outofrange=1
      if (shotz.gt.(bz1+nz)) outofrange=1


c     
c     ONLY INSERT SOURCE IF IN-PLANE
c     

      
      if (rotation.eq.1) then
c        CHECK OUT OF RANGE
         if (shotx.lt.(bx1+1)) outofrange=1
         if (shotx.gt.(bx1+nx))  outofrange=1
         if (shotz.lt.(bz1+1)) outofrange=1
         if (shotz.gt.(bz1+nz)) outofrange=1
         if (outofrange.eq.0) then
            ut(shotx+1,shotz)=ut(shotx+1,shotz)+
     1           source(it)*dx*denu(shotx+1,shotz)
            ut(shotx+1,shotz+1)=ut(shotx+1,shotz+1)-
     1           source(it)*dx*denu(shotx+1,shotz+1)
            wt(shotx,shotz)=wt(shotx,shotz)-
     1           source(it)*dx*denw(shotx,shotz)
            wt(shotx+1,shotz)=wt(shotx+1,shotz)+
     1           source(it)*dx*denw(shotx+1,shotz) 
         endif
      else
c        CHECK OUT OF RANGE
         if (shotx.lt.(bx1+1)) outofrange=1
         if (shotx.gt.(bx1+nx))  outofrange=1
         if (shotz.lt.(bz1+1)) outofrange=1
         if (shotz.gt.(bz1+nz)) outofrange=1
         if (outofrange.eq.0) then
            ut(shotx,shotz)=ut(shotx,shotz)-
     1           source(it)*dx*denu(shotx,shotz)
            ut(shotx+1,shotz)=ut(shotx+1,shotz)+
     1           source(it)*dx*denu(shotx+1,shotz)
            wt(shotx,shotz-1)=wt(shotx,shotz-1)-
     1           source(it)*dx*denw(shotx,shotz-1)
            wt(shotx,shotz)=wt(shotx,shotz)+
     1           source(it)*dx*denw(shotx,shotz)
         endif 
      endif

      
      if (verbose.gt.2) then 
         PRINT*, ' --- BEGIN ADDSOURCE ---'
         PRINT*, ' outofrange=',outofrange
         PRINT*, ' shotx=',shotx,' shotz=',shotz
         PRINT*, ' bx1=',bx1,' bbx1=',bbx1
         PRINT*, ' bz1=',bz1,' bbz1=',bbz1
         PRINT*, ' xs,zs=',xs,zs
         PRINT*, ' source=',source(it)
         PRINT*, ' --- END ADDSOURCE ---'
      end if
      


      return
      end
      
      
