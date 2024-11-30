<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <form action="BoardImageTestPage" method="post" enctype="multipart/form-data" id="form">
        <input type="file" name="file" accept="image/*" required>
        <input type="submit" value="Upload">
    </form>

    <script>
        // Function to run before form submission
        function beforeSubmit(event) {
            event.preventDefault();  // Prevent the form from submitting immediately
            
            // You can add your logic here, for example, validating the file
            const fileInput = document.querySelector('input[type="file"]');
            if (fileInput.files.length === 0) {
                alert("Please select a file.");
                return;
            }

            // You can add any other logic you need before submitting the form
            console.log("File selected:", fileInput.files[0]);
            
            // Now submit the form manually
            //document.getElementById("form").submit();  // This will submit the form
        }

        // Add event listener to the form submit event
        document.getElementById("form").addEventListener("submit", beforeSubmit);
    </script>
</body>
</html>
