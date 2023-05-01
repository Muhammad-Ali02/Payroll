 
<cfoutput>
        <!---         Front End       --->
    <div class="employee_box">
        <div class="text-center">
            <h3 class="box_heading mb-5">Create Survey</h3>
        </div>
        <form name="survey_form" action="" onsubmit="return formValidate();" method="post">
            <input class="form-control mb-3" type="text" name="survey_title" id="survey_title" required placeholder="Enter Title">
            <textarea class="form-control mb-3" type="text" cols="100" rows="8" name="description" id="description" required placeholder="Enter Survey Description"></textarea>
            <input class="form-control mb-3" type="text" name="question" id="question" placeholder="Enter Question">
            <div id="array" style="display: flex;">
                <!-- <div id="index" style="display: flex; overflow: auto; width: 200px; margin-bottom: 30px;">
                    <p id="index"></p>
                </div>
                <div id="value" style="display: flex; flex-wrap: wrap; margin-left: 35px; overflow-wrap: break-word; overflow: auto; margin-bottom: 30px;">
                    <p id="value"></p>
                </div> -->
                <table class="table table-borderless custom-table" id="ajaxTable" style="margin-top: 10px; color: rgba(255, 255, 255, 0.702);">
                    <!-- <thead id="ajaxcol" style="border: 1px solid black; background-color: black; color: white">
            
                    </thead> -->
            
                    <tbody id="Table">
                    </tbody>
                </table>
            </div>
            <div class="d-flex justify-content-between">
                <button type="button" class="btn btn-outline-dark" id="Add_question" onclick="return AddQuestion();">Add Question</button>
                <input type="submit" id="submit" value="Create Survey" class="btn btn-outline-dark">
            </div>
        </form>
    </div>
</cfoutput>
<script>
    var count=1;
    var question_array = [];
    function formValidate(){
        var title = $('#survey_title').val();
        var description = $('#description').val();
        // var question = $('#question').val();
        var length = question_array.length;
        if(title == '' || description == '' || length == 0){
            alert('All Fields Must Be Filled Out And Atleast One survey have Question!');
            return false;
        }else{
            $(document).ready(function(){
                // console.log('hello');
                $.post("insert_survey.cfc?method=Insert_Question&array="+question_array+"&title="+title+"&description="+description, function(data, status){
                    if(data == 'true'){
                        alert('Survey Created Successfully.')
                        return true;
                    }else{ 
                        alert("Opps! Survey is not Created.\n Message :"+data);
                        return false;
                    }
                });
            });
        }
    }
    function AddQuestion(){
        var question = $('#question').val();
        var length= question_array.length;
        // $('#array').prop('display','inline');
        if(question ==''){
            alert('Please Enter Question First and Then Press Add Question Button.');
        }else if(length < 10){
            length = question_array.push(question);
            $('#question').val('');
            // console.log(question_array);
            // question_array.forEach(function(questions,index)
            var counter = question_array.length -1;
            for(i = counter ; i < question_array.length ; i++){
                 $('#Table').append('<tr><td style="width: 175px">Question No. '+ (i+1)+ ' : <td>\<td>'+question_array[i]+'<td><tr>');
                // $('#index').append('question : '+(i+1)+'<br>');
                // $('#value').append(question_array[i]+'<br>');
            };
        }else{
            alert('You can add minimum one and maximum 10 questions only.');
        }
    }
</script>
 