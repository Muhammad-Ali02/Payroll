        </div>
    </div>
    <!-- jQuery CDN - Slim version (=without AJAX) -->
    <!-- <script src="/assets/jquery/jquery_slim.js"></script> -->
    <script language="JavaScript" type="text/javascript" src="/assets/jquery/jquery_slim.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script> -->
    <!-- Popper.JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
    <!-- Bootstrap JS -->
    <!-- <link rel="stylesheet" type="text/css" href="/assets/bootstrap/js/bootstrap.min.js"/> -->
    <script language="JavaScript" type="text/javascript" src="/assets/bootstrap/js/bootstrap.min.js"></script>
    <!-- <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script> -->

    <script type="text/javascript">
        $(document).ready(function () {
            $('#sidebarCollapse').on('click', function () {
                $('#sidebar').toggleClass('active');
                $(this).toggleClass('active');
            });
        });
        
        $(document).ready(function(){
            $('#sidebarCollapse').click(function(){
               if($('#sidebar').hasClass('active')){
                $(this).children().addClass('right')
               }else{
                $(this).children().removeClass('right')
                $(this).children().addClass('left')
                $(this).css("background-color","transparent");
               }
            })
        })
    </script>
</body>
</html>