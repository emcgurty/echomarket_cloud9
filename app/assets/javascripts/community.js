$(document).ready(function () {

        $('input').on('change', function () {

        var current_value = null;
        $("span.error-message").css("visibility", "hidden");
        $("span.error-message").text("");
        var current_id = this.id;
        if (this.id.includes('howManyRecords')) {
            current_id = this.id;
            current_value = $(this).val();

            if ((current_value < 1) || (current_value > 25) || (isNaN(current_value))) {
                $("span#howManyRecords" + ".error-message").css("visibility", "visible");
                $("span#howManyRecords" + ".error-message").text("Please enter a numeric value betweem 1 and 25.");
            }


        } else if (this.id.includes('email')) {
            current_id = this.id;
            /// regEx not working
            var intValue = parseInt(current_id.match(/[0-9]+/)[0], 10);
            current_value = $(this).val();
            
            if (!(isEmail(current_value))) {
                $("span#email" + intValue + ".error-message").css("visibility", "visible");
                $("span#email" + + intValue + ".error-message").text("Please enter a valid email address.");
            }


        } 
        
        
    });

    function isEmail(email) {
        var regex = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
        return regex.test(email);
    }
});
