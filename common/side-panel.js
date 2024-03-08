function switchdiv(switcher, sw, closedname, openedname) {
	console.log("left - switchdiv function called");
	console.log("left - element:", switcher);
	console.log("left - targetId:", sw);
	console.log("left - expandText:", openedname);
	console.log("left - collapseText:", closedname);
	switched = document.getElementById(sw);
	console.log("left - switched:", switched);
	if (switched.style.display == "none") {
		switched.style.display = "block";
		switched.style.marginLeft = "10px";
		switcher.innerText = openedname;
	}  else {
		switched.style.display = "none";
		switcher.innerText = closedname;
	}
	window.event.cancelBubble = true;
	return false;
}

function createchart(type, element, passcount, failcount, warncount, nrcount, passcolor, failcolor, warncolor, nrcolor) {
	console.log("type:", type);
	console.log("element:", element);
	console.log("passcount:", passcount);
	console.log("failcount:", failcount);
	console.log("warncount:", warncount);
	console.log("nrcount:", nrcount);
	const ctx = document.getElementById(element);
	const existingChart = Chart.getChart(ctx);
    if (existingChart) {
        existingChart.destroy(); // Destroy existing chart
    }
	const data = {
	  labels: ['Pass', 'Fail', 'Warning', 'Not Run'],
	  datasets: [{
	    label: 'Test Results',
	    data: [passcount, failcount, warncount, nrcount],
	    backgroundColor: [
	      passcolor,
	      failcolor,
	      warncolor,
	      nrcolor
	    ],
	    borderColor: [
	      '#92D794',
	      '#F4A1A1',
	      '#FBD07B',
	      '#D5D4A0'
	    ],
	    borderWidth: 1
	  }]
	};
	const options = {
	  responsive: true,
	  plugins: { legend: { position: 'right', align:'center' }},
	  maintainAspectRatio : false
	};
	return new Chart(ctx, {
	    type: type,
	    data: data,
	    options: options
	});
}
function clearRightPanel() {
    //var rightPanel = document.getElementById('right-panel');
	var rightPanel = document.querySelector('.lower-right-panel');
    rightPanel.innerHTML = ''; // Clear the content of the right-panel
}

function updateExecutionDetails(executionDetailsContent) {
	var lowerRightPanel = document.querySelector(".lower-right-panel");
	if (lowerRightPanel) {
		lowerRightPanel.innerHTML = executionDetailsContent;
	}
}

function switchContent(event) {
	event.preventDefault();
	var contentDivs = document.querySelectorAll(".content");
	contentDivs.forEach(function(div) {
	  div.style.display = "none";
	});
	var targetDivId = this.id + "div";
	var targetDiv = document.getElementById(targetDivId);
	if (targetDiv) {
	  targetDiv.style.display = "block";
	}
 }

 function switchdivright(switcher, sw) {
	console.log("right - switchdivright function called");
	console.log("right - element:", switcher);
	console.log("right - targetId:", sw);
	// Hide all div 
	var contentDivs = document.querySelectorAll(".right-hide");
	contentDivs.forEach(function(div) {
	  div.style.display = "none";
	});

	// Show the selected div
	switched = document.getElementById(sw);
	switched.style.display = "block";
	switched.style.marginLeft = "10px";
	console.log("right - switched:", switched);

	window.event.cancelBubble = true;
	return false;
}

//<![CDATA[
      window.onclick = function(event) {
		  if ((event.target != document.getElementById('popupwindow')) && (event.target != document.getElementById('openpopupwindow'))) {
		    closeDialog();
		  }
		}
      function openDialog() {
		let popup = document.getElementById('popupwindow')
      	popup.classList.add("openpopupwindow")
      }
      function closeDialog() {
		let popup = document.getElementById('popupwindow')
      	popup.classList.remove("openpopupwindow")
      }
//]]>