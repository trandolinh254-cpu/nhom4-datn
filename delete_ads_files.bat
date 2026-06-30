@echo off
echo Deleting unused Ads and Premium files...
del /F /Q "src\main\java\com\example\asmnews\controller\order\PremiumServlet.java" 2>nul
del /F /Q "src\main\java\com\example\asmnews\controller\order\OrderServlet.java" 2>nul
del /F /Q "src\main\java\com\example\asmnews\controller\auth\MyAdsServlet.java" 2>nul
del /F /Q "src\main\java\com\example\asmnews\controller\admin\AdminAdsServlet.java" 2>nul
del /F /Q "src\main\java\com\example\asmnews\controller\admin\AdminOrderServlet.java" 2>nul

rmdir /S /Q "src\main\java\com\example\asmnews\controller\ads" 2>nul
rmdir /S /Q "src\main\java\com\example\asmnews\repository\ads" 2>nul
rmdir /S /Q "src\main\java\com\example\asmnews\entity\ads" 2>nul
rmdir /S /Q "src\main\webapp\WEB-INF\views\ads" 2>nul

echo Done deleting files!
echo Running Maven clean package...
call mvn clean package
pause
