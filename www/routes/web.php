<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    try
    {
        $serverName = "tcp:123.123.123.123,1433";
        $connectionOptions = array("Database"=>"", "Uid"=>"", "PWD"=>"");
        $conn = sqlsrv_connect($serverName, $connectionOptions);
        if($conn == false)
        {
            var_dump(sqlsrv_errors());
            die();
        }else{
            var_dump($conn);
        }
        
        $tsql = "";
        
        $stmt = sqlsrv_query($conn, $tsql);
        
        while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
        {
            var_dump($row);
        }
        
    }
    catch(Exception $e)
    {
        echo("Error!");
    }
    // return view('welcome');
});