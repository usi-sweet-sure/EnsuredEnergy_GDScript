/**
	Sustainable Energy Development game modeling the Swiss energy Grid.
	Copyright (C) 2023 Università della Svizzera Italiana

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

// Models the resource managed by the EnergyManager
public struct Energy {
	public float SupplySummer; // Total Supply for the next turn for the summer months
	public float SupplyWinter; // Total Supply for the next turn for the winter months
	public float DemandSummer; // Total Demand for the next turn for the summer months
	public float DemandWinter; // Total Demand for the next turn for the winter months
	public float SurplusSummer; // Amount of excess energy produced in the summer months (represents an underproduction if negative)
	public float SurplusWinter; // Amount of excess energy produced in the winter months (represents an underproduction if negative)


	// Basic constructor for the Energy Ressource
	public Energy(float SS=0, float SW=0, float DS=0, float DW=0, float SurS=0, float SurW=0) {
		SupplySummer = SS;
		SupplyWinter = SW;
		DemandSummer = DS;
		DemandWinter = DW;
		SurplusSummer = SurS;
		SurplusWinter = SurW;
	}
}

public partial class EnergyManager : Node {

	// Max value allowed by the UI
	public const int MAX_ENERGY_BAR_VAL = 1000;

	// Keep track of all of the placed power plants
	private List<PowerPlant> PowerPlants;

	// Keeps track of the current energy values
	private Energy E;

	// Previous turn's import amount
	private int ImportAmount;


	// ==================== GODOT Method Overrides ====================

	// Called when the node enters the scene tree for the first time.
	public override void _Ready() {
		// Initialize the fields
		PowerPlants = new List<PowerPlant>();
		E = new Energy();
	}

	// ==================== Public API ====================

	// Updates the current internal power plant list
	public void _UpdatePowerPlants(List<PowerPlant> lP) {
		// Clear the current list to be safe
		PowerPlants.Clear();

		// Fill in the contents of the list with those of the given one
		foreach(PowerPlant pp in lP) {
			PowerPlants.Add(pp);
		}
	}

	// Retrieves the imported amount based on the value given by the import slider
	// The given amount is the percentage of the total demand that is imported
	// The importSummer flag reprensents whether or not we import in the summer
	public (int, int?) _ComputeImportAmount(float import_perc, bool importSummer=false) => (
		(int)Math.Ceiling(import_perc * E.DemandWinter),
		importSummer ? (int)Math.Ceiling(import_perc * E.DemandSummer) : null
	);

	// Computes the energy levels that will be present for the next turn
	public Energy _NextTurn(float import_perc, bool importSummer=false) {
		// TODO: Update the Energy by aggregating the capacity from the model's power plants
		// and updating the model
		E = EstimateEnergy(import_perc, importSummer);
		return E;
	}

	// Computes the initial values for the energy resource
	public Energy _GetEnergyValues(float import_perc, bool importSummer=false) {
		// TODO: Update the Energy by aggregating the capacity from the model's power plants
		// and updating the model
		E = EstimateEnergy(import_perc, importSummer);
		return E;
	}

	// ==================== Helper Methods ====================  

	// Aggregate the current supply into a single value
	private float AggregateSupply() =>
		// Sum all capacities for each active power plant
		PowerPlants.Where(pp => pp._GetLiveness()).Select(pp => pp._GetCapacity() * pp._GetAvailability()).Sum();

	// Aggregate the current capacities into a single value
	private int AggregateCapacity() =>
		PowerPlants.Where(pp => pp._GetLiveness()).Select(pp => pp._GetCapacity()).Sum();

	// Computes the total imported energy amount
	// Given the percentage selected by the player
	private int ComputeTotalImportAmount(float import_perc, bool importSummer=false) {
		// Retrieve the import amounts
		var (import_amount_w, import_amount_s) = _ComputeImportAmount(import_perc, importSummer);

		// Compute the final amount
		return (import_amount_w + (import_amount_s.HasValue ? import_amount_s.Value : 0));
	}

	// Estimate the values for the next turn (in case of no network or demo)
	private Energy EstimateEnergy(float import_perc, bool importSummer=false) {
		// Compute the imported supply
		int imported = ComputeTotalImportAmount(import_perc, importSummer);

		// Aggregate supply
		float supply = AggregateSupply();

		// Take the imports into account
		float supply_w = supply + imported;
		float supply_s = supply + (importSummer ? imported : 0);

		// Compute the Excess and store it in a separate field
		float excess_w = supply_w - MAX_ENERGY_BAR_VAL;
		float excess_s = supply_s - MAX_ENERGY_BAR_VAL;
		
		// Normalize the supply
		supply_w = Math.Max(0, Math.Min(supply_w, MAX_ENERGY_BAR_VAL));
		supply_s = Math.Max(0, Math.Min(supply_s, MAX_ENERGY_BAR_VAL));

		float demandEstimate = MAX_ENERGY_BAR_VAL * 0.5f;
		return new Energy(supply_s, supply_w, demandEstimate, demandEstimate, excess_s, excess_w);
	}

}
