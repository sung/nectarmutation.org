/*
-- nectar.css is enough
-- hence, it's of no use to use this 
-- position: fixed !important;
// ==UserScript==
// @name           Facebook Static Blue Bar
// @namespace      Facebook
// @include        http://www.facebook.com/*
// ==/UserScript==
var x = document.getElementById('yellowBar');
var y = document.getElementById('pageHead');
x.setAttribute('style', 'top:0px;position:fixed;-moz-box-shadow: 0px 0px 5px 3px #797979;z-index:100;');
y.setAttribute('style', 'width:1000px;');

if (document.getElementById('header') != null)
	document.getElementById('header').setAttribute('style', 'display:scroll;position:fixed;top:0px;z-index:100;');

var pd = document.createElement('div');
pd.style.display = 'block';
pd.style.height = '41px';
pd.style.background = '#FFFFFF';
document.body.insertBefore(pd, document.body.childNodes[1]);
*/

/* form clear */
function clearDefault(el) {
	if (el.defaultValue==el.value) el.value = ""
};

/* superfish menu
/static/js/superfish.js
*/
$(document).ready(function() { 
	$('ul.sf-menu').superfish(); 
}); 

/* inputWithImage 
// moved to root/src/Site/sub_search.tt2 (calls lib/js/inputWithImage.tt2)
http://buildinternet.com/2009/01/changing-form-input-styles-on-focus-with-jquery/

/* jqtransform
/static/js/jquery.jqtransform.js
$(function() {
    //find all form with class jqtransform and apply the plugin
    $("form.jqtransform").jqTransform();
});
*/


/* tipsy tooltip
/static/js/jquery.tipsy.js
*/
$(function() {
    $('#menu a').tipsy({fade:'true', gravity:'e'});
    $('#wrapper a').tipsy({fade:'true', gravity: $.fn.tipsy.autoNS});
    $('.tipsy_r').tipsy({gravity:'w', fade:'true'});
    $('.tipsy_l').tipsy({gravity:'e', fade:'true'});
    $('.tipsy_t').tipsy({gravity:'s', fade:'true'});
    $('.tipsy_b').tipsy({gravity:'n', face:'true'});
    $('#login_box [title]').tipsy({trigger:'focus',gravity:'w'}); //failed -not working
	$('a[rel=tipsy1]').tipsy({gravity:'s', trigger: 'manual'}); //failed - now working
	$('a[rel=tipsy2]').tipsy({gravity:'s', trigger: 'manual'});
	$('a[rel=tipsy3]').tipsy({gravity:'s', trigger: 'manual'});
	$('a[rel=tipsy4]').tipsy({gravity:'s', trigger: 'manual'});
});

/* Basic boxy
* mainly by <a href='#' class='boxy'>
*/
$(function() {
	$('.boxy').boxy({title:'Nectar'});
});

/* boxy with form */
$(function() {
	/* Boxy
	Contact modal boxy
	http://www.varnagiris.net/2009/04/11/ajax-feedback-form-using-jquery-boxy-plugin/
	*/
    /* set global variable for boxy window */
    var contactBoxy = null;
    /* what to do when click on contact us link */
    $('.contact_us').click(function(){
        var boxy_content;
        boxy_content += "<div style=\"width:300px; height:300px\"><form id=\"feedback\">";
        boxy_content += "<p>Subject<br /><input type=\"text\" name=\"subject\" id=\"subject\" size=\"35\" value=\"[NECTAR]\"/></p><p>Your email address:<br /><input type=\"text\" name=\"sender\" id=\"sender\" size=\"35\" /></p><p>Comment:<br /><textarea name=\"comment\" id=\"comment\" ONFOCUS=\"clearDefault(this)\" cols=\"35\" rows=\"8\">Cheers Sung, I'll buy you a pint!</textarea></p><br /><input type=\"submit\" name=\"submit\" value=\"Send >>\" />";
        boxy_content += "</form></div>";
        contactBoxy = new Boxy(boxy_content, {
            title: "Send feedback to Sung",
            draggable: false,
            modal: true,
            behaviours: function(c) {
                c.find('#feedback').submit(function() {
                    Boxy.get(this).setContent("<div style=\"width: 300px; height: 300px; margin: 20px auto;\">Sending...</div>");
                    // submit form by ajax using post and send 3 values: subject, sender, comment
                    $.post("/main/sendmail", { subject: c.find("input[name='subject']").val(), sender: c.find("input[name='sender']").val(), comment: c.find("#comment").val()},
                    function(data){
                        /*set boxy content to data from ajax call back*/
                        contactBoxy.setContent("<div style=\"width: 300px; height: 300px; margin: 20px auto;\">"+data+"</div>");
                    });
                    return false;
                });
            }
        });
        return false;
    });

	/* login Boxy trigger by 'click' 
	 */
	var loginBoxy = null;
	$('.login_boxy').click(function(){
		var boxy_content;
		boxy_content +="<div id=\"login_box\" style=\"margin: 10px;\"><form id=\"login\">";
		boxy_content +="<p>User name:<br/>";
		boxy_content +="<input type=\"text\" name=\"username\" id=\"username\" size=\"15\"/ title=\"your account\"/></p>";
		boxy_content +="<p>Password:<br/>";
		boxy_content +="<input type=\"password\" name=\"password\" id=\"password\" size=\"15\"/ title=\"your password\"/></p>";
		boxy_content +="<input type=\"submit\" value=\"Login\"/>";
		boxy_content +="<a style=\"font-size: 10px; text-align: right;\" title=\"create account\" href=\"/main/register\">need an account?</a><br/>";
		boxy_content +="</form></div>";

		loginBoxy = new Boxy(boxy_content, {
			title: "Login to Nectar",
            draggable: false,
            modal: true,
            behaviours: function(c) {
                c.find('#login').submit(function() {
                    Boxy.get(this).setContent("<div>Logging you in...</div>");
                    // submit form by ajax using post and send two values: 'username' and 'password' 
                    $.post("/main/login", { username: c.find("input[name='username']").val(), password: c.find("input[name='password']").val()},
						function(data){
							/*set boxy content to data from ajax call back*/
							if(data == "auth_ok"){
								loginBoxy.hideAndUnload(window.location = "/");
							}else{
								//loginBoxy.setContent("<div style=\"width: 300px; margin: 20px auto;\">"+data+"</div>");
								loginBoxy.setContent("<div id=\"login_box\" style=\"margin: 10px;\"><form id=\"login\">"+data+"<p>User name:<br/><input type=\"text\" name=\"username\" id=\"username\" size=\"15\"/ title=\"your account\"/></p><p>Password:<br/><input type=\"password\" name=\"password\" id=\"password\" size=\"15\"/ title=\"your password\"/></p><input type=\"submit\" value=\"Login\"/></form></div>");
							};
						}
					); // end of $.post()
                    return false;
                }); // end of c.find().submit
            } //end of behaviours
		});
		return false;
	});

	/* Boxy searching interface for CSE
	 * gogole custome search  (class='cse')
	 */
	var cseBoxy= null;
	$('.cse').click(function(){
		var boxy_content;
		boxy_content +="<div id=\"cse\" style=\"width:300px\">";
		boxy_content +="<script>";
		boxy_content +="(function() {";
		boxy_content +=" var cx = '016251604127889350075:xyhplwkzcwm';";
		boxy_content +=" var gcse = document.createElement('script');";
		boxy_content +=" gcse.type = 'text/javascript';";
		boxy_content +=" gcse.async = true;";
		boxy_content +=" gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +";
		boxy_content +=" '//www.google.com/cse/cse.js?cx=' + cx;";
		boxy_content +=" var s = document.getElementsByTagName('script')[0];";
		boxy_content +=" s.parentNode.insertBefore(gcse, s);";
		boxy_content +=" })();";
		boxy_content +="</script>";
		boxy_content +="<gcse:search></gcse:search></div>";

		cseBoxy = new Boxy(boxy_content, {
			title: "NECTAR Google Custom Search",
            draggable: false,
            modal: true,
		});
		return true;
	});

	/* Boxy searching interface with a prompt dialog 
	 * keyword search
	 */
	var keywordBoxy = null;
	$('.search_keyword').click(function(){
		var boxy_content;
		boxy_content +="<form id=\"search_keyword\" method=\"get\" action=\"/search/keyword\">";
		boxy_content +="<input type=\"text\" name=\"id\" id=\"id\" size=\"30\" value=\"cardiomyopathy\" ONFOCUS=\"clearDefault(this)\"/>";
		boxy_content +="<input type=\"submit\" value=\"Go\"/>";
		boxy_content +="</form>";

		keywordBoxy = new Boxy(boxy_content, {
			title: "Search by diseaes keywords",
            draggable: false,
            modal: true,
            behaviours: function(c) {
                c.find('#search_keyword').submit(function() {
                    //Boxy.get(this).setContent("<div><p>Searching.........</p></div>");
                    // submit form by ajax using post and send 1 values: id
					// [debug] url (search/by_ids) not working - don't know why. (using 'action' above at the moment)
                    $.get("/search/by_ids", { id_type:"disease", id:c.find("input[name='id']").val() });
					return true;
                }); // end of .submit
            } //end of behaviours
		});
		return true;
	});

	/* Boxy searching interface with a prompt dialog 
	 * smiles string search
	 */
	var smileBoxy = null;
	$('.search_smiles').click(function(){
		var boxy_content;
		boxy_content +="<h2>Please enter your SMILES string:</h2>";
		boxy_content +="<form id=\"search_smiles\" method=\"get\" action=\"/search/smiles\">";
		boxy_content +="<input type=\"text\" name=\"id\" id=\"id\" size=\"50\" value=\"C([C@@H]1[C@H]([C@@H]([C@H]([C@@H](O1)O)O)O)O)O\" ONFOCUS=\"clearDefault(this)\"/>";
		boxy_content +="<input type=\"submit\" value=\"Go\"/>";
		boxy_content +="</form>";

		keywordBoxy = new Boxy(boxy_content, {
			title: "Search by SMILES string",
            draggable: false,
            modal: true,
            behaviours: function(c) {
                c.find('#search_keyword').submit(function() {
                    //Boxy.get(this).setContent("<div><p>Searching.........</p></div>");
                    // submit form by ajax using post and send 1 values: id
					// [debug] url (search/by_ids) NOT WORKING - don't know why. (using 'action' above at the moment)
                    $.get("/search/by_ids", { id_type:"id", id:c.find("input[name='id']").val() });
					return true;
                }); // end of .submit
            } //end of behaviours
		});
		return true;
	}); // end of smile

});

/* Tooltip using jQuery Tooltip
 * http://flowplayer.org/tools/tooltip.html
$(document).ready(function() { 
    $(".general_list_table a[title]").tooltip({tip: '.plain_tooltip_small', effect: 'fade', fadeOutSpeed: 80}); 

    $(".general_list_table th[title]").tooltip({tip: '.plain_tooltip_small', effect: 'fade', fadeOutSpeed: 80}); 

});
*/

