window.onload = function () {
	var trigger = document.getElementById("bouton");
	console.log(trigger);

	document.querySelector(".bouton").addEventListener("click", async (event) => {
		if (!navigator.clipboard) {
			// Clipboard API not available
			return;
		}
		var text = document.querySelector("#div1").textContent;
		try {
			await navigator.clipboard.writeText(text);
			event.target.textContent = "Copié ✅";
		} catch (err) {
			console.error("Failed to copy!", err);
		}
	});
};
