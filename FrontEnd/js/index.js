// Your web app's Firebase configuration
var firebaseConfig = {
	apiKey: "AIzaSyDaxX0xGXy48D3XEZoC0GrpBzAUbb8Ab5s",
	authDomain: "scheduleapplication-30f30.firebaseapp.com",
	databaseURL: "https://scheduleapplication-30f30.firebaseio.com",
	projectId: "scheduleapplication-30f30",
	storageBucket: "scheduleapplication-30f30.appspot.com",
	messagingSenderId: "1083352420929",
	appId: "1:1083352420929:web:b2f6d83347e05970fbacc0",
	measurementId: "G-S3Y2H93D1D"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();

firebase.auth.Auth.Persistence.SESSION;

firebase.auth().signOut();

$("#signin").on("submit", function(event) {
	event.preventDefault();

	let email = $("#signin-email").val();
	let password = $("#signin-password").val();

	if (email != "" && password != "") {
		let result = firebase.auth().signInWithEmailAndPassword(email, password);
		result.catch(function(error) {
			let errorCode = error.code;
			let errorMessage = error.message;

			console.log(errorCode);
			console.log(errorMessage);
			alert("Message: " + errorMessage);
		});
	}
	else {
		alert("Form is incomplete. Please fill out all fields.");
	}
});

$("#signup").on("submit", function(event) {
	event.preventDefault();

	let email = $("#email").val();
	let password = $("#password").val();
	let cpassword = $("#cpassword").val();

	if (email != "" && password != "" && cpassword != "") {
		console.log(password);
		console.log(cpassword);
		if (password == cpassword) {
			let result = firebase.auth().createUserWithEmailAndPassword(email, password);
			result.catch(function(error) {
				let errorCode = error.code;
				let errorMessage = error.message;

				console.log(errorCode);
				console.log(errorMessage);
				alert("Message: " + errorMessage);
			});
		}
		else {
			alert("Passwords do not match.");
		}
	}
	else {
		alert("Form is incomplete. Please fill out all fields.");
	}
});