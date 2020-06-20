﻿using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.Linq;
using System;

public class GrailMapGenerator : MonoBehaviour {
	public InfiniteMap Map;

	public int MapHeight = 6;
    public int CollapseSize = 10;

	public BoundaryConstraint[] BoundaryConstraints;

	public bool ApplyBoundaryConstraints = true;

	public ModuleData ModuleData;
    private List<Slot> containers;

    public Vector3 GetRandomPosition()
    {
        Vector3Int position = containers[UnityEngine.Random.Range(0, containers.Count())].Position;
        return GetWorldspacePosition(position);
    }

	public Vector3 GetWorldspacePosition(Vector3Int position) {
		return this.transform.position
			+ Vector3.up * InfiniteMap.BLOCK_SIZE / 2f
			+ position.ToVector3() * InfiniteMap.BLOCK_SIZE;
	}

	public Vector3Int GetMapPosition(Vector3 worldSpacePosition) {
		var pos = (worldSpacePosition - this.transform.position) / InfiniteMap.BLOCK_SIZE;
		return Vector3Int.FloorToInt(pos + new Vector3(0.5f, 0, 0.5f));
	}

    [ContextMenu("Clear")]
	public void Clear() {
		var children = new List<Transform>();
		foreach (Transform child in this.transform) {
			children.Add(child);
		}
		foreach (var child in children) {
			GameObject.DestroyImmediate(child.gameObject);
		}
		this.Map = null;
	}

	public void Initialize() {
		ModuleData.Current = this.ModuleData.Modules;
		this.Clear();
		this.Map = new InfiniteMap(this.MapHeight);
		if (this.ApplyBoundaryConstraints && this.BoundaryConstraints != null && this.BoundaryConstraints.Any()) {
			this.Map.ApplyBoundaryConstraints(this.BoundaryConstraints);
		}
	}

    public void Collapse()
    {
        Map.Collapse(Vector3Int.zero, new Vector3Int(CollapseSize, Map.Height, CollapseSize), true);
    }

    [ContextMenu("Build")]
    public void Build()
    {
        Initialize();
        Collapse();
        BuildAllSlots();
        containers = Map.GetAllSlots().Where(s => s.Module != null && s.Module.container).ToList();
    }

	public bool Initialized {
		get {
			return this.Map != null;
		}
	}
	
	public void Update() {
		if (this.Map == null || this.Map.BuildQueue == null) {
			return;
		}

		int itemsLeft = 50;

		while (this.Map.BuildQueue.Count != 0 && itemsLeft > 0) {
			var slot = this.Map.BuildQueue.Peek();
			if (slot == null) {
				return;
			}
			if (this.BuildSlot(slot)) {
				itemsLeft--;
			}
			this.Map.BuildQueue.Dequeue();
		}
	}

	public bool BuildSlot(Slot slot) {
		if (slot.GameObject != null) {
#if UNITY_EDITOR
			GameObject.DestroyImmediate(slot.GameObject);
#else
			GameObject.Destroy(slot.GameObject);
#endif
		}

		if (!slot.Collapsed || slot.Module.Prototype.Spawn == false) {
			return false;
		}
		var module = slot.Module;
		if (module == null) { // Can be null due to race conditions
			return false;
		}

		var gameObject = GameObject.Instantiate(module.Prototype.gameObject);
		gameObject.name = module.Prototype.gameObject.name + " " + slot.Position;
		GameObject.DestroyImmediate(gameObject.GetComponent<ModulePrototype>());
		gameObject.transform.parent = this.transform;
		gameObject.transform.position = this.GetWorldspacePosition(slot.Position);
		gameObject.transform.rotation = Quaternion.Euler(Vector3.up * 90f * module.Rotation);
		slot.GameObject = gameObject;
		return true;
	}

	public void BuildAllSlots() {
		while (this.Map.BuildQueue.Count != 0) {
			this.BuildSlot(this.Map.BuildQueue.Dequeue());
		}
	}

	public bool VisualizeSlots = false;

#if UNITY_EDITOR
    [DrawGizmo(GizmoType.InSelectionHierarchy | GizmoType.NotInSelectionHierarchy)]
	static void DrawGizmo(MapBehaviour mapBehaviour, GizmoType gizmoType) {
		if (!mapBehaviour.VisualizeSlots) {
			return;
		}
		if (mapBehaviour.Map == null) {
			return;
		}
		foreach (var slot in mapBehaviour.Map.GetAllSlots()) {
			if (slot.Collapsed || slot.Modules.Count == ModuleData.Current.Length) {
				continue;
			}
			Handles.Label(mapBehaviour.GetWorldspacePosition(slot.Position), slot.Modules.Count.ToString());
		}
	}
#endif
}
