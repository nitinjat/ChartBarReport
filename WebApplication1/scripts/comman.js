/// <reference path="jquery-1.3.2-vsdoc2.js" />

$.fn.clearValidation = function () { var v = $(this).validate(); $('[name]', this).each(function () { v.successList.push(this); v.showErrors(); }); v.resetForm(); v.reset(); };

// NOTE: Clears residual validation errors from the library "jquery.validate.js". 
// By Travis J and Questor
// [Ref.: https://stackoverflow.com/a/16025232/3223785 ]
function clearJqValidErrors(formElement) {

    // NOTE: Internal "$.validator" is exposed through "$(form).validate()". By Travis J
    var validator = $(formElement).validate();

    // NOTE: Iterate through named elements inside of the form, and mark them as 
    // error free. By Travis J
    $(":input", formElement).each(function () {
        // NOTE: Get all form elements (input, textarea and select) using JQuery. By Questor
        // [Refs.: https://stackoverflow.com/a/12862623/3223785 , 
        // https://api.jquery.com/input-selector/ ]

        validator.successList.push(this); // mark as error free
        validator.showErrors(); // remove error messages if present
    });
    validator.resetForm(); // remove error class on name elements and clear history
    validator.reset(); // remove all error and success data

    // NOTE: For those using bootstrap, there are cases where resetForm() does not 
    // clear all the instances of ".error" on the child elements of the form. This 
    // will leave residual CSS like red text color unless you call ".removeClass()". 
    // By JLewkovich and Nick Craver
    // [Ref.: https://stackoverflow.com/a/2086348/3223785 , 
    // https://stackoverflow.com/a/2086363/3223785 ]
    $(formElement).find("label.error").hide();
    $(formElement).find(".error").removeClass("error");

}

function clearValidationSummary(outterElement) {
    $('.validation-summary-valid', outterElement).html('');
    $('.validation-summary-errors', outterElement).html('');
    $('.validation-summary-errors', outterElement).addClass('validation-summary-valid');
    $('.validation-summary-valid', outterElement).removeClass('validation-summary-errors');
}

function toJSONString(form) {
    var obj = {};
    var elements = form.querySelectorAll("input, select, textarea");
    for (var i = 0; i < elements.length; ++i) {
        var element = elements[i];
        var name = element.name;
        var value = element.value;

        if (name) {
            obj[name] = value;
        }
    }

    return JSON.stringify(obj);
}

function GetFormDetailsFor(ele) {
    var $frm = $("#" + ele.id).closest("form");
    var frm = $frm[0];
    var frmId = "#" + $frm[0].id;
    var jFormDetails = { frm: frm, frmId: frm.id, $frm: $frm };
    return jFormDetails;
}

/************** Login *****************/
    function ShowLogin() {
        $.get('/account/loginForm',
            function (data, textStatus, jqXHR) {  // success callback
                //modalWiget997
                var e1 = $("#modal997 .modal-dialog");
                e1.html(data);
                $('#modal997').modal('show');
                //since we are getting the html here, we need to parse the form in it for the validators to work
                $.validator.unobtrusive.parse("form");
                //$("#frmLogin").validate()
                //InitValidationForLoginForm();
            }
        );
    }

    function InitValidationForLoginForm() {
        /*
        $("#frmLogin").validate({
            //form: '#frmLogin',
            
            onError: function ($form) {
                alert('Validation of form ' + $form.attr('id') + ' failed!');
            },
            onSuccess: function ($form) {
                alert('The form ' + $form.attr('id') + ' is valid!');
                return false; // Will stop the submission of the form
            },
            onValidate: function ($form) {
                return {
                    element: $('#loginMsg'),
                    message: 'This input has an invalid value for some reason'
                }
            },
            onElementValidate: function (valid, $el, $form, errorMess) {
                console.log('Input ' + $el.attr('name') + ' is ' + (valid ? 'VALID' : 'NOT VALID'));
            }
        });*/

        $('#frmLogin').validate({
            errorClass: 'help-block animation-slideDown', // You can change the animation class for a different entrance animation - check animations page
            errorElement: 'div',
            errorPlacement: function (error, e) {
                e.parents('.form-group > div').append(error);
            },
            highlight: function (e) {

                $(e).closest('.form-group').removeClass('has-success has-error').addClass('has-error');
                $(e).closest('.help-block').remove();
            },
            success: function (e) {
                e.closest('.form-group').removeClass('has-success has-error');
                e.closest('.help-block').remove();
            },
            rules: {
                'Email': {
                    required: true,
                    email: true
                },

                'Password': {
                    required: true,
                    minlength: 6
                },
                /*
                'ConfirmPassword': {
                    required: true,
                    equalTo: '#Password'
                }*/
            },
            messages: {
                'Email': 'Please enter valid email address',

                'Password': {
                    required: 'Please provide a password',
                    minlength: 'Your password must be at least 6 characters long'
                },

                'ConfirmPassword': {
                    required: 'Please provide a password',
                    minlength: 'Your password must be at least 6 characters long',
                    equalTo: 'Please enter the same password as above'
                }
            }
        });
    
    }

    function OnLoginSubmit(submitBtn) {
        event.preventDefault();
        var frmObj = GetFormDetailsFor(submitBtn);
        var frm = frmObj.frm;
        var $frm = frmObj.$frm;

        $("#loginMsg", frm).html("").hide();
        //var frm = $("#frmUploadContent")[0]
        //frm.classList.add('was-validated');
        var isValid = $frm.valid();
        if (!isValid)
            return false;
        //var email = $($frm + " input[id='Email']").val();
        //var password = $($frm + " input[id='Password']").val();
        var submitUrl = frm.action;// + '?returnUrl=' + window.location;
        frm.action = submitUrl;
        var data = toJSONString(frm);
        var jqxhr = $.post({ url: submitUrl, type: 'post', contentType: 'application/json; charset=utf-8', data: data }, function (jResponse) {
            if (jResponse.status == "success") {
                if (jResponse.data.refresh)
                    window.location.reload();
            }
            else {
                $("#loginMsg", frm).show().html(jResponse.errorMsg);
            }
        }).done(function (jqXHR, textStatus, jReponse) {
            //alert("second success");
        })
        .fail(function (jqXHR, textStatus, jReponse) {
            //alert("error");
        })
        .always(function (jqXHR, textStatus, jReponse) {
            //alert("finished");
        });

        return false;
    }

    function OnExtLoginSubmit(externalSubmitBtn, authProviderName) {
        event.preventDefault();
        var frmDetails = GetFormDetailsFor(externalSubmitBtn);
        //var data = JSON.stringify({ provider: authProviderName });
        //var submitUrl = frmDetails.frm.action + '?returnUrl=' + encodeURI(window.location.pathname);// window.location.pathname;
        //var jqxhr = $.post({ url: submitUrl, type: 'post', contentType: 'application/json; char set=utf-8', data: data }, function (jResponse) {
        //    if (jResponse.status == "success") {
        //        if (jResponse.data.refresh)
        //            window.location.reload();
        //    }
        //    else {

        //    }
        //}).done(function (jqXHR, textStatus, jReponse) {
        //    //alert("second success");
        //})
        //.fail(function (jqXHR, textStatus, jReponse) {
        //    //alert("error");
        //})
        //.always(function (jqXHR, textStatus, jReponse) {
        //    //alert("finished");
        //});
        
        $("#returnUrl", frmDetails.frm).val(window.location.pathname);
        frmDetails.frm.submit();
    }

    function ShowRegistration() {
        //$("#modal997").modal('hide');
        $.get('/account/RegistrationForm',
            function (data, textStatus, jqXHR) {  // success callback
                //modalWiget997
                var e1 = $("#modal997 .modal-dialog");
                e1.html(data);
                $('#modal997').modal('show');
                //since we are getting the html here, we need to parse the form in it for the validators to work
                $.validator.unobtrusive.parse("form");
                //$("#frmLogin").validate()
                //InitValidationForLoginForm();
            }
        );
        return false;
    }

    function OnRegisterSubmit(e) {
        event.preventDefault();
        var frmObj = GetFormDetailsFor(e);
        var frm = frmObj.frm;
        var $frm = frmObj.$frm;

        $("#registrationMsg", frm).html("").hide();
        var isValid = $frm.valid();
        if (!isValid)
            return false;
        var submitUrl = frm.action;// + '?returnUrl=' + window.location;
        frm.action = submitUrl;
        var data = toJSONString(frm);
        var jqxhr = $.post({ url: submitUrl, type: 'post', contentType: 'application/json; charset=utf-8', data: data }, function (jResponse) {
            if (jResponse.status == "success") {
                if (jResponse.data.refresh)
                    window.location.reload();
                var succMsg = "User registered successfully. If you wish to login now, please click <a onclick='ShowLogin(); return false;'>here</a>."
                $("#registrationMsg", frm).show().html(succMsg);
            }
            else {
                $("#registrationMsg", frm).show().html(jResponse.errorMsg);
            }
        }).done(function (jqXHR, textStatus, jReponse) {
            //alert("second success");
        })
        .fail(function (jqXHR, textStatus, jReponse) {
            //alert("error");
        })
        .always(function (jqXHR, textStatus, jReponse) {
            //alert("finished");
        });

        return false;
    }

    function Logout() {
        var submitUrl = "/account/logout";
        var jqxhr = $.post({ url: submitUrl, type: 'post', contentType: 'application/json; charset=utf-8', data: '' }, function (jResponse) {
            if (jResponse.status == "success") {
                if (jResponse.data.refresh)
                    window.location.reload();
            }
            else {
                alert("Error loging out!");
            }

        }).done(function (jqXHR, textStatus, jReponse) {
            //alert("second success");
        })
        .fail(function (jqXHR, textStatus, jReponse) {
            //alert("error");
        })
        .always(function (jqXHR, textStatus, jReponse) {
            //alert("finished");
        });

        return false;
    }

    $("#divUsername").hover(function() {
        $('.emailcontainer').show('slow')
    },
        function() {
            setTimeout(function() {
                if(!($('.emailcontainer:hover').length > 0))
                    $('.emailcontainer').hide('slow');
            }, 300);
        });


/************ Login End ***************/

    function OnResetClicked(e) {
        var frmObj = GetFormDetailsFor(e);
        frmObj.frm.classList.remove('was-validated');
        frmObj.frm.classList.add('needs-validation');
        //var validator = $("#" + frmObj.frmId).data("validator");
        //validator.resetForm();
        $("#" + frmObj.frmId).clearValidation();
        $("form").validate().resetForm();
        $("form").validate().reset();
        //clearJqValidErrors($("#" + frmObj.frmId));
        //clearValidationSummary(frmObj.frm);
    }

    function ShowSuccessMsg(id, html) {
        $("#" + id).html('<div id="divUploadSuccMsg" class="alert alert-success alert-dismissible fade show" role="alert"></div>');
        //$("#" + id).addClass("alert alert-success alert-dismissible fade show");
        html =  html + '<button type="button" class="close" data-dismiss="alert">&times;</button>' ;
        $("#" + "divUploadSuccMsg").html(html);
    }

    function ShowErrorMsg(id, html) {
        $("#" + id).addClass("alert alert-danger alert-dismissible fade show");
        html = '<button type="button" class="close" data-dismiss="alert">&times;</button>' + html;
        $("#" + id).html(html);
    }

    function SetProgressBar(eId, percentComplete) {
        $('#' + eId).text(percentComplete + '%');
        var showWidth = percentComplete + "%";                        
        $('#' + eId).css('width', showWidth);
    }

    function ResetProgressBar(eId, show1Percent, fadeOn100Percent) {
        
        var showWidth = "0%";
        if (show1Percent)
            showWidth = "1px";
        $('#' + eId).text('0% complete');
        if (fadeOn100Percent) {
            setTimeout(function () {
                $('#' + eId).css('width', showWidth);
                $('#' + eId).hide();                                
                $('#' + eId).show();                
            }, 1000);
        }
        else {
            $('#' + eId).css('width', showWidth);
        }

    }
