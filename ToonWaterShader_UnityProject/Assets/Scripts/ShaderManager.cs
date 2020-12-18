using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// This class passes input from the UI into the ToonWater shader

public class ShaderManager : MonoBehaviour
{
    [SerializeField] private Renderer Water;
    private Material ToonWater;

    // Start is called before the first frame update
    void Start()
    {
        ToonWater = Water.material;
    }

    void Update() {
        if (Input.GetKeyDown("escape"))
            Application.Quit();
    }

    public void SetScrolling(bool b) {
        float _ScrollBool  = 0;
        if (b) _ScrollBool = 1;
        ToonWater.SetFloat("_ScrollBool", _ScrollBool);
    }
}
