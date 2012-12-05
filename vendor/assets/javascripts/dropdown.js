$(document).ready(function()
{

$(".account").click(function()
{
var X=$(this).attr('id');
if(X=='activoTu')
{
$(".submenu").hide();
$(this).attr('id', 'desactivadoTu'); 
}
else
{
$(".submenu").show();
$(this).attr('id', 'activoTu');
}

});

//Mouse click on sub menu
$(".submenu").mouseup(function()
{
return false
});

//Mouse click on my account link
$(".account").mouseup(function()
{
return false
});


//Document Click
$(document).mouseup(function()
{
$(".submenu").hide();
$(".account").attr('id', '');
});
});